import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../categories/presentation/providers/categories_provider.dart';
import '../../../../suppliers/presentation/providers/suppliers_provider.dart';
import '../../../../suppliers/data/models/supplier_model.dart';
import '../../../data/models/product_model.dart';
import '../../providers/products_provider.dart';

final activeSuppliersStreamProvider = StreamProvider<List<SupplierModel>>((ref) {
  return ref.watch(suppliersRemoteDataSourceProvider).getActiveSuppliersStream();
});

class ProductFormDialog extends ConsumerStatefulWidget {
  final ProductModel? productToEdit;
  const ProductFormDialog({super.key, this.productToEdit});

  @override
  ConsumerState<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _lowStockThresholdCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _germinationRateCtrl;

  String? _selectedCategoryId;
  String? _selectedSupplierId;
  String _selectedSeason = 'all';
  bool _isActive = true;
  bool _hasExpiryTracking = false;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(text: p?.price.toString() ?? '');
    _stockCtrl = TextEditingController(text: p?.stockQuantity.toString() ?? '0');
    _lowStockThresholdCtrl = TextEditingController(text: p?.lowStockThreshold.toString() ?? '10');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _germinationRateCtrl = TextEditingController(text: p?.germinationRate?.toString() ?? '');

    _selectedCategoryId = p?.categoryId;
    _selectedSupplierId = p?.defaultSupplierId;
    _selectedSeason = p?.season ?? 'all';
    _isActive = p?.isActive ?? true;
    _hasExpiryTracking = p?.hasExpiryTracking ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _lowStockThresholdCtrl.dispose();
    _skuCtrl.dispose();
    _germinationRateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsNotifierProvider);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final suppliersAsync = ref.watch(activeSuppliersStreamProvider);

    final isEditing = widget.productToEdit != null;
    final isProcessing = isEditing
        ? state.updateStatus == RequestStatus.loading
        : state.createStatus == RequestStatus.loading;

    ref.listen(productsNotifierProvider, (previous, next) {
      final status = isEditing ? next.updateStatus : next.createStatus;
      final prevStatus = isEditing ? previous?.updateStatus : previous?.createStatus;

      if (status != prevStatus) {
        if (status == RequestStatus.success) {
          Navigator.of(context).pop();
          CustomSnackBar.showSuccess(
            context: context,
            message: isEditing ? 'تم تحديث بيانات المنتج بنجاح' : 'تمت إضافة المنتج بنجاح',
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
        isEditing ? "تعديل بيانات المنتج" : "إضافة منتج جديد",
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      content: SizedBox(
        width: 650.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: _nameCtrl,
                  labelText: "اسم المنتج *",
                  prefixIcon: Icons.label_important_outline,
                  enabled: !isProcessing,
                  validator: requiredValidator,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _descriptionCtrl,
                  labelText: "الوصف *",
                  prefixIcon: Icons.description_outlined,
                  enabled: !isProcessing,
                  validator: requiredValidator,
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _priceCtrl,
                        labelText: "السعر *",
                        prefixIcon: Icons.payments_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        enabled: !isProcessing,
                        validator: (v) => v == null || double.tryParse(v) == null ? "الرجاء إدخال سعر صحيح" : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _stockCtrl,
                        labelText: "المخزون *",
                        prefixIcon: Icons.inventory_2_outlined,
                        keyboardType: TextInputType.number,
                        enabled: !isProcessing && !isEditing,
                        readOnly: isEditing,
                        validator: (v) => v == null || int.tryParse(v) == null ? "الرجاء إدخال رقم صحيح" : null,
                        helperText: isEditing ? "تعديل الكميات يتم عبر إدارة المخزون فقط" : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _skuCtrl,
                        labelText: "رمز التتبع (SKU) / الباركود",
                        prefixIcon: Icons.qr_code_2_outlined,
                        enabled: !isProcessing,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _lowStockThresholdCtrl,
                        labelText: "الحد الأدنى للتنبيه بالمخزون",
                        prefixIcon: Icons.warning_amber_rounded,
                        keyboardType: TextInputType.number,
                        enabled: !isProcessing,
                        validator: (v) => v == null || int.tryParse(v) == null ? "الرجاء إدخال رقم صحيح" : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: categoriesAsync.when(
                        data: (categoryList) {
                          return CustomDropdownFormField<String?>(
                            value: _selectedCategoryId,
                            labelText: "التصنيف الرئيسي *",
                            items: categoryList.map((cat) {
                              return DropdownMenuItem<String?>(
                                value: cat.id,
                                child: Text( cat.name),
                              );
                            }).toList(),
                            onChanged: isProcessing
                                ? null
                                : (value) => setState(() => _selectedCategoryId = value),
                            validator: (v) => v == null ? "التصنيف مطلوب" : null,
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (err, stack) => const Text("Error loading categories"),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: suppliersAsync.when(
                        data: (supplierList) {
                          return CustomDropdownFormField<String?>(
                            value: _selectedSupplierId,
                            labelText: "المورد الافتراضي",
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text("العام / غير محدد"),
                              ),
                              ...supplierList.map((sup) {
                                return DropdownMenuItem<String?>(
                                  value: sup.id,
                                  child: Text(sup.companyName),
                                );
                              }),
                            ],
                            onChanged: isProcessing
                                ? null
                                : (value) => setState(() => _selectedSupplierId = value),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (err, stack) => const Text("Error loading suppliers"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomDropdownFormField<String>(
                        value: _selectedSeason,
                        labelText: "الموسم الزراعي *",
                        items: [
                          DropdownMenuItem(value: 'spring', child: Text(locale == 'ar' ? 'الربيع' : 'Spring')),
                          DropdownMenuItem(value: 'summer', child: Text(locale == 'ar' ? 'الصيف' : 'Summer')),
                          DropdownMenuItem(value: 'autumn', child: Text(locale == 'ar' ? 'الخريف' : 'Autumn')),
                          DropdownMenuItem(value: 'winter', child: Text(locale == 'ar' ? 'الشتاء' : 'Winter')),
                          DropdownMenuItem(value: 'all', child: Text(locale == 'ar' ? 'طوال العام' : 'All Year')),
                        ],
                        onChanged: isProcessing ? null : (value) => setState(() => _selectedSeason = value!),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _germinationRateCtrl,
                        labelText: "نسبة الإنبات (مثال: 90)",
                        prefixIcon: Icons.shutter_speed_outlined,
                        keyboardType: TextInputType.number,
                        enabled: !isProcessing,
                        validator: (v) => v != null && v.isNotEmpty && int.tryParse(v) == null ? "يجب إدخال نسبة صحيحة" : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("المنتج نشط ومتاح للطلب"),
                  value: _isActive,
                  onChanged: isProcessing ? null : (v) => setState(() => _isActive = v ?? true),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("تتبع تاريخ الصلاحية"),
                  subtitle: const Text("تفعيل هذا الخيار لإرسال تنبيهات عند اقتراب انتهاء الصلاحية"),
                  value: _hasExpiryTracking,
                  onChanged: isProcessing ? null : (v) => setState(() => _hasExpiryTracking = v ?? false),
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
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14.sp),
          ),
        ),
        SizedBox(width: 8.w),
        ButtonApp(
          text: isEditing ? "تحديث" : "حفظ المنتج",
          isLoading: isProcessing,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_selectedCategoryId == null) {
                CustomSnackBar.showError(context: context, message: "التصنيف مطلوب");
                return;
              }

              final product = ProductModel(
                id: widget.productToEdit?.id ?? '',
                categoryId: _selectedCategoryId!,
                name: _nameCtrl.text.trim(),
                price: double.parse(_priceCtrl.text.trim()),
                stockQuantity: int.parse(_stockCtrl.text.trim()),
                description: _descriptionCtrl.text.trim(),
                season: _selectedSeason,
                germinationRate: _germinationRateCtrl.text.trim().isEmpty
                    ? null
                    : int.parse(_germinationRateCtrl.text.trim()),
                imageUrl: widget.productToEdit?.imageUrl,
                isActive: _isActive,
                sku: _skuCtrl.text.trim().isEmpty ? null : _skuCtrl.text.trim(),
                lowStockThreshold: int.parse(_lowStockThresholdCtrl.text.trim()),
                hasExpiryTracking: _hasExpiryTracking,
                defaultSupplierId: _selectedSupplierId,
                createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
              );

              if (isEditing) {
                ref.read(productsNotifierProvider.notifier).updateProduct(product);
              } else {
                ref.read(productsNotifierProvider.notifier).addProduct(product);
              }
            }
          },
        ),
      ],
    );
  }
}
