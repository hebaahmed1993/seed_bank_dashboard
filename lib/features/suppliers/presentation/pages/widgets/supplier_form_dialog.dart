import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🎯 1. إضافة ScreenUtil

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/theme/theme/app_constants.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/utils/validators.dart'; // 🎯 2. استدعاء Validators
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/button_app.dart'; // 🎯 3. استدعاء ButtonApp
import '../../../data/models/supplier_model.dart';
import '../../providers/suppliers_provider.dart';

class SupplierFormDialog extends ConsumerStatefulWidget {
  final SupplierModel? supplierToEdit;
  const SupplierFormDialog({super.key, this.supplierToEdit});

  @override
  ConsumerState<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends ConsumerState<SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _phone2Ctrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;

  // State للمدينة
  String? _selectedCityId;
  String? _selectedCityName;

  @override
  void initState() {
    super.initState();
    _companyNameCtrl = TextEditingController(text: widget.supplierToEdit?.companyName ?? '');
    _nameCtrl = TextEditingController(text: widget.supplierToEdit?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.supplierToEdit?.phone ?? '');
    _phone2Ctrl = TextEditingController(text: widget.supplierToEdit?.phone2 ?? '');
    _emailCtrl = TextEditingController(text: widget.supplierToEdit?.email ?? '');
    _addressCtrl = TextEditingController(text: widget.supplierToEdit?.address ?? '');

    _selectedCityId = widget.supplierToEdit?.cityId.isNotEmpty == true
        ? widget.supplierToEdit!.cityId
        : null;
    _selectedCityName = widget.supplierToEdit?.city;
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _phone2Ctrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suppliersNotifierProvider);
    final theme = Theme.of(context);

    final isEditing = widget.supplierToEdit != null;
    final isProcessing = isEditing
        ? state.updateStatus == RequestStatus.loading
        : state.addStatus == RequestStatus.loading;

    ref.listen(suppliersNotifierProvider, (previous, next) {
      final status = isEditing ? next.updateStatus : next.addStatus;
      final prevStatus = isEditing ? previous?.updateStatus : previous?.addStatus;

      if (status != prevStatus) {
        if (status == RequestStatus.success) {
          Navigator.of(context).pop();
          CustomSnackBar.showSuccess(
            context: context,
            message: isEditing ? 'تم تحديث بيانات المورد بنجاح' : 'تمت إضافة المورد بنجاح',
          );
        } else if (status == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? 'حدث خطأ غير متوقع',
          );
        }
      }
    });

    return AlertDialog(
      title: Text(
        isEditing ? "تعديل بيانات المورد" : "إضافة مورد جديد",
        style: TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp, // 🎯 تطبيق sp
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      content: SizedBox(
        width: 600.w, // 🎯 تطبيق w
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: _companyNameCtrl,
                  labelText: "اسم الشركة أو المشتل *",
                  prefixIcon: Icons.business,
                  enabled: !isProcessing,
                  validator: requiredValidator, // 🎯 استخدام Validator الموحد
                ),
                SizedBox(height: 16.h), // 🎯 تطبيق h

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _nameCtrl,
                        labelText: "اسم مسؤول التواصل",
                        prefixIcon: Icons.person_outline,
                        enabled: !isProcessing,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _emailCtrl,
                        labelText: "البريد الإلكتروني",
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isProcessing,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _phoneCtrl,
                        labelText: "رقم الهاتف الأساسي *",
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        enabled: !isProcessing,
                        validator: phoneNumberValidator, // 🎯 استخدام Validator الموحد
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _phone2Ctrl,
                        labelText: "رقم هاتف إضافي (اختياري)",
                        prefixIcon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        enabled: !isProcessing,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomDropdownFormField<String>(
                        value: _selectedCityId,
                        labelText: "المدينة *",
                        items: StaticData.libyanCities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city['id'],
                            child: Text(city['name']!),
                          );
                        }).toList(),
                        onChanged: isProcessing
                            ? null
                            : (val) {
                          setState(() {
                            _selectedCityId = val;
                            _selectedCityName = StaticData.libyanCities
                                .firstWhere((c) => c['id'] == val)['name'];
                          });
                        },
                        validator: requiredValidator, // 🎯 استخدام Validator الموحد
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        controller: _addressCtrl,
                        labelText: "العنوان التفصيلي",
                        prefixIcon: Icons.map_outlined,
                        enabled: !isProcessing,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isProcessing ? null : () => Navigator.pop(context),
          child: Text(
            "إلغاء",
            style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp), // 🎯
          ),
        ),
        SizedBox(width: 8.w),
        // 🎯 3. استخدام ButtonApp مع التمرير السليم للحالات
        ButtonApp(
          text: isEditing ? "تحديث" : "حفظ المورد",
          isLoading: isProcessing,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final supplier = SupplierModel(
                id: widget.supplierToEdit?.id ?? '',
                companyName: _companyNameCtrl.text.trim(),
                name: _nameCtrl.text.trim(),
                phone: _phoneCtrl.text.trim(),
                phone2: _phone2Ctrl.text.trim(),
                email: _emailCtrl.text.trim(),
                city: _selectedCityName ?? '',
                cityId: _selectedCityId ?? '',
                address: _addressCtrl.text.trim(),
                isActive: widget.supplierToEdit?.isActive ?? true,
                createdAt: widget.supplierToEdit?.createdAt ?? DateTime.now(),
              );

              if (isEditing) {
                ref.read(suppliersNotifierProvider.notifier).updateSupplier(supplier);
              } else {
                ref.read(suppliersNotifierProvider.notifier).addSupplier(supplier);
              }
            }
          },
        ),
      ],
    );
  }
}