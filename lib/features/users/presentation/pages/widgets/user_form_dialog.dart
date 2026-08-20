import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_error_messages.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../../locations/presentation/providers/locations_provider.dart';
import '../../../data/models/user_model.dart';
import '../../providers/users_provider.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  final UserModel? user;

  const UserFormDialog({super.key, this.user});

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedCity;

  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _selectedCity = widget.user?.cityId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedCity == null) {
      if (_selectedCity == null) {
        CustomSnackBar.showError(
            context: context,
            message: 'الرجاء اختيار المدينة'
        ); // 🎯 استبدال ScaffoldMessenger
      }
      return;
    }

    final cities = ref.read(citiesStreamProvider).value ?? [];
    final selectedCityName = cities.firstWhere(
            (city) => city.cityId == _selectedCity,
        orElse: () => throw Exception('المدينة غير موجودة')
    ).name;

    final userModel = UserModel(
      uid: isEditMode ? widget.user!.uid : '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      accountTypeId: 'user',
      cityId: _selectedCity!,
      cityName: selectedCityName,
      isBlocked: isEditMode ? widget.user!.isBlocked : false,
      createdAt: isEditMode ? widget.user!.createdAt : DateTime.now(),
    );

    if (isEditMode) {
      ref.read(usersNotifierProvider.notifier).updateUser(userModel);
    } else {
      ref.read(usersNotifierProvider.notifier).createUser(userModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final citiesAsync = ref.watch(citiesStreamProvider);
    final usersState = ref.watch(usersNotifierProvider);
    final theme = Theme.of(context); // 🎯 استدعاء الثيم

    final bool isActionLoading = isEditMode
        ? usersState.updateUserStatus == RequestStatus.loading
        : usersState.createUserStatus == RequestStatus.loading;

    ref.listen(usersNotifierProvider, (previous, next) {
      final prevStatus = isEditMode ? previous?.updateUserStatus : previous?.createUserStatus;
      final nextStatus = isEditMode ? next.updateUserStatus : next.createUserStatus;

      if (prevStatus != nextStatus) {
        if (nextStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
              context: context,
              message: isEditMode ? 'تم التعديل بنجاح' : 'تم الإضافة بنجاح'
          ); // 🎯 استبدال ScaffoldMessenger
        } else if (nextStatus == RequestStatus.error) {
          CustomSnackBar.showError(
              context: context,
              message: next.errorMessage ?? AppErrorMessages.generalError
          ); // 🎯 استبدال ScaffoldMessenger
        }
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: theme.colorScheme.surface, // 🎯 التوافق مع لون الخلفية الديناميكي
      child: Container(
        width: 600.w,
        padding: EdgeInsets.all(32.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditMode ? 'تعديل بيانات المستخدم' : 'إضافة مستخدم جديد',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: theme.primaryColor), // 🎯 لون ديناميكي
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted), // 🎯 المسمى الجديد
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(height: 32.h),

              Row(
                children: [
                  Expanded(child: CustomTextFormField(controller: _nameController, labelText: l10n.fullNameLabel, prefixIcon: Icons.person_outline, validator: requiredValidator)),
                  SizedBox(width: 16.w),
                  Expanded(child: CustomTextFormField(controller: _phoneController, labelText: l10n.phoneLabel, prefixIcon: Icons.phone_android_outlined, keyboardType: TextInputType.phone, validator: phoneNumberValidator)),
                ],
              ),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(child: CustomTextFormField(controller: _emailController, labelText: l10n.emailLabel, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: requiredValidator)),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: citiesAsync.when(
                      data: (cities) {
                        return CustomDropdownFormField<String>(
                          value: _selectedCity,
                          labelText: l10n.cityLabel,
                          items: cities.map((city) => DropdownMenuItem(value: city.cityId, child: Text(city.name, style: const TextStyle(color: AppColors.textPrimaryLight)))).toList(),
                          onChanged: (value) => setState(() => _selectedCity = value),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const Text('خطأ في تحميل المدن', style: TextStyle(color: AppColors.error)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              if (isEditMode) ...[
                OutlinedButton.icon(
                  onPressed: () => CustomSnackBar.showInfo(
                    context: context,
                    message: 'جاري إرسال الرابط...',
                  ),
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('إرسال رابط إعادة تعيين كلمة المرور'),
                ),
                SizedBox(height: 24.h),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel, style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 16.sp))
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 180.w,
                    child: ButtonApp(
                      text: isEditMode ? 'حفظ ' : l10n.saveAccountCloud,
                      isLoading: isActionLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}