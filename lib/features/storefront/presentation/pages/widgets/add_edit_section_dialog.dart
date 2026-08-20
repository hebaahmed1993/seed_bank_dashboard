import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/home_section_type.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/enums/section_filter_type.dart';
import '../../../../../core/enums/selection_mode.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../categories/presentation/providers/categories_provider.dart';
import '../../../data/models/home_section_model.dart';
import '../../providers/home_sections_provider.dart';
import '../../providers/home_sections_state.dart';

class AddEditSectionDialog extends ConsumerStatefulWidget {
  final HomeSectionModel? sectionToEdit;

  const AddEditSectionDialog({super.key, this.sectionToEdit});

  @override
  ConsumerState<AddEditSectionDialog> createState() => _AddEditSectionDialogState();
}

class _AddEditSectionDialogState extends ConsumerState<AddEditSectionDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _orderCtrl;
  late final TextEditingController _limitCtrl;
  late final TextEditingController _productIdsCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _targetUrlCtrl;

  // 🎯 المتغير الخاص بتخزين IDs التصنيفات المحددة من الـ Checkboxes
  late List<String> _selectedCategoryIds;

  late HomeSectionType _sectionType;
  late SelectionMode _selectionMode;
  SectionFilterType? _dynamicFilterType;
  bool _isActive = true;

  bool get _isEditing => widget.sectionToEdit != null;

  @override
  void initState() {
    super.initState();
    final s = widget.sectionToEdit;
    _titleCtrl = TextEditingController(text: s?.title ?? '');
    _orderCtrl = TextEditingController(text: s?.order.toString() ?? '1');
    _limitCtrl = TextEditingController(text: s?.limit.toString() ?? '10');
    _productIdsCtrl = TextEditingController(text: s?.productIds.join(', ') ?? '');
    _imageUrlCtrl = TextEditingController(text: s?.imageUrl ?? '');
    _targetUrlCtrl = TextEditingController(text: s?.targetUrl ?? '');

    // 🎯 تهيئة قائمة التصنيفات المحددة
    _selectedCategoryIds = List<String>.from(s?.categoryIds ?? []);

    _sectionType = s?.type ?? HomeSectionType.products;
    _selectionMode = s?.selectionMode ?? SelectionMode.dynamicMode;
    _dynamicFilterType = s?.dynamicFilterType;
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _orderCtrl.dispose();
    _limitCtrl.dispose();
    _productIdsCtrl.dispose();
    _imageUrlCtrl.dispose();
    _targetUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeSectionsNotifierProvider);
    final theme = Theme.of(context);

    final isProcessing = _isEditing
        ? state.updateStatus == RequestStatus.loading
        : state.addStatus == RequestStatus.loading;

    ref.listen<HomeSectionsState>(homeSectionsNotifierProvider, (prev, next) {
      final status = _isEditing ? next.updateStatus : next.addStatus;
      final prevStatus = _isEditing ? prev?.updateStatus : prev?.addStatus;
      if (status == prevStatus) return;

      if (status == RequestStatus.success) {
        Navigator.of(context).pop();
        CustomSnackBar.showSuccess(
          context: context,
          message: _isEditing ? 'تم تحديث العنصر بنجاح' : 'تم إضافة العنصر بنجاح',
        );
        if (_isEditing) {
          ref.read(homeSectionsNotifierProvider.notifier).resetUpdateStatus();
        } else {
          ref.read(homeSectionsNotifierProvider.notifier).resetAddStatus();
        }
      } else if (status == RequestStatus.failure) {
        CustomSnackBar.showError(
          context: context,
          message: next.errorMessage ?? 'حدث خطأ غير متوقع',
        );
      }
    });

    final isProductOrCategory = _sectionType == HomeSectionType.products || _sectionType == HomeSectionType.categories;

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(_isEditing ? Icons.edit_outlined : Icons.add_box_outlined, color: theme.colorScheme.primary, size: 22.r),
          SizedBox(width: 10.w),
          Text(_isEditing ? 'تعديل العنصر' : 'إضافة عنصر جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        ],
      ),
      content: SizedBox(
        width: 600.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionDivider(label: 'نوع المحتوى'),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<HomeSectionType>(
                        title: const Text('منتجات'),
                        value: HomeSectionType.products,
                        groupValue: _sectionType,
                        onChanged: isProcessing ? null : (v) => setState(() => _sectionType = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<HomeSectionType>(
                        title: const Text('تصنيفات'),
                        value: HomeSectionType.categories,
                        groupValue: _sectionType,
                        onChanged: isProcessing ? null : (v) => setState(() => _sectionType = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<HomeSectionType>(
                        title: const Text('إعلان (بنر)'),
                        value: HomeSectionType.banner,
                        groupValue: _sectionType,
                        onChanged: isProcessing ? null : (v) => setState(() => _sectionType = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _titleCtrl,
                  labelText: 'العنوان *',
                  enabled: !isProcessing,
                  validator: (v) => v == null || v.trim().isEmpty ? 'العنوان مطلوب' : null,
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _orderCtrl,
                        labelText: 'الترتيب *',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => v == null || int.tryParse(v) == null ? 'أدخل رقماً' : null,
                      ),
                    ),
                    if (isProductOrCategory) ...[
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _limitCtrl,
                          labelText: 'الحد الأقصى للعناصر *',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1 ? 'أدخل رقماً صحيحاً' : null,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.h),

                SwitchListTile.adaptive(
                  title: const Text('نشط ومرئي'),
                  value: _isActive,
                  onChanged: isProcessing ? null : (v) => setState(() => _isActive = v),
                ),
                SizedBox(height: 16.h),

                // 🎯 الحقول الخاصة بكل نوع
                if (_sectionType == HomeSectionType.products) ...[
                  const _SectionDivider(label: 'وضع اختيار المنتجات'),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<SelectionMode>(
                          title: const Text('ديناميكي'),
                          value: SelectionMode.dynamicMode,
                          groupValue: _selectionMode,
                          onChanged: (v) => setState(() => _selectionMode = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<SelectionMode>(
                          title: const Text('يدوي'),
                          value: SelectionMode.manual,
                          groupValue: _selectionMode,
                          onChanged: (v) => setState(() => _selectionMode = v!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (_selectionMode == SelectionMode.dynamicMode)
                    CustomDropdownFormField<SectionFilterType>(
                      value: _dynamicFilterType,
                      labelText: 'نوع التصفية *',
                      items: SectionFilterType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
                      onChanged: (v) => setState(() => _dynamicFilterType = v),
                      validator: (v) => v == null ? 'مطلوب' : null,
                    )
                  else
                    CustomTextFormField(
                      controller: _productIdsCtrl,
                      labelText: 'معرفات المنتجات (بفاصلة ,)',
                      maxLines: 2,
                      validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
                    ),
                ] else if (_sectionType == HomeSectionType.categories) ...[
                  // 🎯 بيانات التصنيفات والتحديد التفاعلي
                  const _SectionDivider(label: 'تحديد التصنيفات'),
                  SizedBox(height: 8.h),
                  ref.watch(categoriesStreamProvider).when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            'لا توجد تصنيفات مضافة في النظام بعد.',
                            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                          ),
                        );
                      }

                      final isAllSelected = _selectedCategoryIds.length == categories.length;
                      final isNoneSelected = _selectedCategoryIds.isEmpty;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isNoneSelected
                                    ? 'عرض جميع التصنيفات تلقائياً'
                                    : 'محدد (${_selectedCategoryIds.length} من ${categories.length})',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isNoneSelected ? Colors.teal : theme.colorScheme.primary,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: isProcessing
                                    ? null
                                    : () {
                                  setState(() {
                                    if (isAllSelected) {
                                      _selectedCategoryIds.clear();
                                    } else {
                                      _selectedCategoryIds = categories.map((c) => c.id).toList();
                                    }
                                  });
                                },
                                icon: Icon(
                                  isAllSelected ? Icons.deselect : Icons.select_all,
                                  size: 18.r,
                                ),
                                label: Text(
                                  isAllSelected ? 'إلغاء التحديد (عرض الكل)' : 'تحديد الكل',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            constraints: BoxConstraints(maxHeight: 180.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected = _selectedCategoryIds.contains(category.id);

                                return CheckboxListTile(
                                  dense: true,
                                  title: Text(
                                    category.name,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: category.productCount > 0
                                      ? Text('عدد المنتجات: ${category.productCount}', style: TextStyle(fontSize: 11.sp))
                                      : null,
                                  value: isSelected,
                                  onChanged: isProcessing
                                      ? null
                                      : (bool? checked) {
                                    setState(() {
                                      if (checked == true) {
                                        _selectedCategoryIds.add(category.id);
                                      } else {
                                        _selectedCategoryIds.remove(category.id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '* ملاحظة: عند عدم تحديد أي تصنيف، سيتم عرض جميع التصنيفات بناءً على الحد الأقصى المحدد.',
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                          ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => Text(
                      'حدث خطأ أثناء تحميل التصنيفات: $err',
                      style: TextStyle(color: Colors.red, fontSize: 13.sp),
                    ),
                  ),
                ] else ...[
                  // حقول الإعلانات (Banner Fields)
                  const _SectionDivider(label: 'بيانات الإعلان'),
                  SizedBox(height: 8.h),
                  CustomTextFormField(
                    controller: _imageUrlCtrl,
                    labelText: 'رابط الصورة (Image URL) *',
                    enabled: !isProcessing,
                    validator: (v) => v == null || v.trim().isEmpty ? 'رابط الصورة مطلوب' : null,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: _targetUrlCtrl,
                    labelText: 'الرابط المستهدف (Target URL)',
                    enabled: !isProcessing,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ButtonApp(text: _isEditing ? 'تحديث' : 'حفظ', isLoading: isProcessing, onPressed: _handleSubmit),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final section = HomeSectionModel(
      id: widget.sectionToEdit?.id ?? '',
      title: _titleCtrl.text.trim(),
      order: int.parse(_orderCtrl.text.trim()),
      isActive: _isActive,
      type: _sectionType,
      selectionMode: _sectionType == HomeSectionType.products ? _selectionMode : null,
      dynamicFilterType: (_sectionType == HomeSectionType.products && _selectionMode == SelectionMode.dynamicMode) ? _dynamicFilterType : null,
      productIds: (_sectionType == HomeSectionType.products && _selectionMode == SelectionMode.manual)
          ? _productIdsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
          : [],
      // 🎯 تمرير قائمة التصنيفات المحددة
      categoryIds: _sectionType == HomeSectionType.categories ? _selectedCategoryIds : [],
      limit: (_sectionType == HomeSectionType.products || _sectionType == HomeSectionType.categories) ? int.parse(_limitCtrl.text.trim()) : 10,
      imageUrl: _sectionType == HomeSectionType.banner ? _imageUrlCtrl.text.trim() : null,
      targetUrl: _sectionType == HomeSectionType.banner ? _targetUrlCtrl.text.trim() : null,
      createdAt: widget.sectionToEdit?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      ref.read(homeSectionsNotifierProvider.notifier).updateSection(section);
    } else {
      ref.read(homeSectionsNotifierProvider.notifier).addSection(section);
    }
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.w),
        const Expanded(child: Divider()),
      ],
    );
  }
}