import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // للنسخ إلى الحافظة
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/utils/password_generator.dart'; // 🎯
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../data/models/staff_model.dart';
import '../../providers/staff_provider.dart';

class AddEditStaffDialog extends ConsumerStatefulWidget {
  final StaffModel? staffToEdit;
  const AddEditStaffDialog({super.key, this.staffToEdit});

  @override
  ConsumerState<AddEditStaffDialog> createState() => _AddEditStaffDialogState();
}

class _AddEditStaffDialogState extends ConsumerState<AddEditStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController; // 🎯

  String? _selectedRoleId;
  bool _isPasswordVisible = false; // 🎯 للتحكم بإخفاء/إظهار كلمة المرور
  bool get isEditing => widget.staffToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staffToEdit?.name ?? '');
    _emailController = TextEditingController(text: widget.staffToEdit?.email ?? '');
    _phoneController = TextEditingController(text: widget.staffToEdit?.phone ?? '');
    _passwordController = TextEditingController();
    _selectedRoleId = widget.staffToEdit?.accountTypeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final newPassword = PasswordGenerator.generate();
    setState(() {
      _passwordController.text = newPassword;
      _isPasswordVisible = true; // إظهارها لكي تتمكني من نسخها
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(staffNotifierProvider);
    final accountTypesAsync = ref.watch(accountTypesStreamProvider);

    final isLoading = isEditing
        ? state.updateStaffRoleStatus == RequestStatus.loading
        : state.addStaffStatus == RequestStatus.loading;

    ref.listen(staffNotifierProvider, (previous, next) {
      final statusToCheck = isEditing ? next.updateStaffRoleStatus : next.addStaffStatus;
      final prevStatusToCheck = isEditing ? previous?.updateStaffRoleStatus : previous?.addStaffStatus;

      if (statusToCheck != prevStatusToCheck) {
        if (statusToCheck == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: isEditing ? l10n.adminUpdatedSuccess : l10n.adminAddedSuccess,
          );
        } else if (statusToCheck == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Icon(isEditing ? Icons.manage_accounts : Icons.person_add_alt_1, color: colorScheme.primary, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            isEditing ? l10n.editAdminRole : l10n.addNewAdmin,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 450.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: _nameController,
                labelText: l10n.nameColumn,
                enabled: !isEditing && !isLoading,
                validator: requiredValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _emailController,
                labelText: l10n.emailColumn,
                enabled: !isEditing && !isLoading,
              //  validator: emailValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _phoneController,
                labelText: l10n.phoneColumn,
                enabled: !isEditing && !isLoading,
                validator: phoneNumberValidator,
              ),
              SizedBox(height: 16.h),

              // 🎯 حقل كلمة المرور يظهر فقط في حالة إضافة موظف جديد
              if (!isEditing) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _passwordController,
                        labelText: l10n.password, // استخدمي مفتاح الترجمة الصحيح
                        obscureText: !_isPasswordVisible,
                        enabled: !isLoading,
                        validator: (value) => value!.isEmpty ? l10n.requiredField : null,
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        //     color: colorScheme.primary,
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       _isPasswordVisible = !_isPasswordVisible;
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.autorenew, color: colorScheme.primary),
                        tooltip: 'توليد كلمة مرور',
                        onPressed: isLoading ? null : _generatePassword,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],

              accountTypesAsync.when(
                data: (roles) {
                  final validRoles = roles.where((r) => r.id != 'user').toList();

                  return CustomDropdownFormField<String>(
                    value: _selectedRoleId,
                    labelText: l10n.roleColumn,
                    items: validRoles.map((role) {
                      return DropdownMenuItem(
                        value: role.id,
                        child: Text(role.typeName.isNotEmpty ? role.typeName : role.name, style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                      setState(() {
                        _selectedRoleId = value;
                      });
                    },
                    validator: requiredValidator,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.unexpectedError, style: TextStyle(color: colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14.sp)),
        ),
        SizedBox(
          width: 150.w,
          height: 45.h,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () {
              if (_formKey.currentState!.validate() && _selectedRoleId != null) {
                if (isEditing) {
                  ref.read(staffNotifierProvider.notifier).updateStaffRole(
                    staffId: widget.staffToEdit!.id,
                    newRoleId: _selectedRoleId!,
                  );
                } else {
                  // 🎯 إرسال البيانات بما فيها كلمة المرور
                  final newStaff = StaffModel(
                    id: '',
                    accountTypeId: _selectedRoleId!,
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    phone: _phoneController.text.trim(),
                    isBlocked: false,
                    createdAt: DateTime.now(),
                    password: _passwordController.text.trim(), // 🎯 نمررها هنا
                  );
                  ref.read(staffNotifierProvider.notifier).addStaff(newStaff);
                }
              }
            },
            text: isLoading ? l10n.savingProgress : l10n.save,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}