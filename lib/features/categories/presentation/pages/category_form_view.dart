import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🎯 إضافة ScreenUtil

import '../../../../core/enums/request_status.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/widgets/button_app.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/category_model.dart';
import '../providers/categories_provider.dart';
import '../providers/categories_state.dart';

class CategoryFormView extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final CategoryModel? categoryToEdit;

  const CategoryFormView({
    super.key,
    required this.onCancel,
    this.categoryToEdit,
  });

  @override
  ConsumerState<CategoryFormView> createState() => _CategoryFormViewState();
}

class _CategoryFormViewState extends ConsumerState<CategoryFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  bool _isSubCategory = false;
  CategoryModel? _selectedParent;

  bool get _isEditing => widget.categoryToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryToEdit?.name ?? '');

    if (_isEditing && widget.categoryToEdit!.parentId != null) {
      _isSubCategory = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesNotifierProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    final isProcessing = categoriesState.addCategoryStatus == RequestStatus.loading ||
        categoriesState.updateCategoryStatus == RequestStatus.loading;

    // 🎯 مراقبة حالة الإضافة والتعديل عبر ref.listen
    ref.listen<CategoriesState>(categoriesNotifierProvider, (prev, next) {
      final status = _isEditing ? next.updateCategoryStatus : next.addCategoryStatus;
      final prevStatus = _isEditing ? prev?.updateCategoryStatus : prev?.addCategoryStatus;

      if (status == prevStatus) return;

      if (status == RequestStatus.success) {
        CustomSnackBar.showSuccess(
          context: context,
          message: _isEditing ? 'تم تحديث التصنيف بنجاح' : 'تم إضافة التصنيف بنجاح',
        );
        if (_isEditing) {
          ref.read(categoriesNotifierProvider.notifier).resetUpdateStatus();
        } else {
          ref.read(categoriesNotifierProvider.notifier).resetAddStatus();
        }
        widget.onCancel();
      } else if (status == RequestStatus.failure) {
        CustomSnackBar.showError(
          context: context,
          message: next.errorMessage ?? 'حدث خطأ غير متوقع',
        );
      }
    });

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: isProcessing ? null : widget.onCancel,
            icon: Icon(Icons.arrow_back, size: 20.r),
            label: Text(
              'العودة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
          SizedBox(height: 24.h),

          Center(
            child: Container(
              width: 650.w,
              padding: EdgeInsets.all(28.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12.r,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: 'اسم التصنيف *',
                      enabled: !isProcessing,
                      validator: (v) => v == null || v.trim().isEmpty ? 'اسم التصنيف مطلوب' : null,
                    ),
                    SizedBox(height: 20.h),

                    // اختيار نوع التصنيف (رئيسي / فرعي)
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text('تصنيف رئيسي', style: TextStyle(fontSize: 14.sp)),
                            value: false,
                            groupValue: _isSubCategory,
                            onChanged: isProcessing
                                ? null
                                : (val) => setState(() {
                              _isSubCategory = val!;
                              _selectedParent = null;
                            }),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text('تصنيف فرعي', style: TextStyle(fontSize: 14.sp)),
                            value: true,
                            groupValue: _isSubCategory,
                            onChanged: isProcessing
                                ? null
                                : (val) => setState(() => _isSubCategory = val!),
                          ),
                        ),
                      ],
                    ),

                    // اختيار التصنيف الأب في حال كان فرعياً
                    if (_isSubCategory) ...[
                      SizedBox(height: 20.h),
                      categoriesAsync.when(
                        data: (list) {
                          final availableParents = list
                              .where((c) => c.id != widget.categoryToEdit?.id)
                              .toList();

                          if (_isEditing && _selectedParent == null && widget.categoryToEdit!.parentId != null) {
                            try {
                              _selectedParent = availableParents.firstWhere(
                                    (c) => c.id == widget.categoryToEdit!.parentId,
                              );
                            } catch (_) {}
                          }

                          return DropdownButtonFormField<CategoryModel?>(
                            decoration: InputDecoration(
                              labelText: 'اختر التصنيف الأب *',
                              labelStyle: TextStyle(fontSize: 14.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            initialValue: _selectedParent,
                            items: availableParents
                                .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name, style: TextStyle(fontSize: 14.sp)),
                            ))
                                .toList(),
                            onChanged: isProcessing
                                ? null
                                : (val) => setState(() => _selectedParent = val),
                            validator: (val) => _isSubCategory && val == null ? 'يجب اختيار تصنيف أب' : null,
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => Text('خطأ في تحميل القائمة', style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],

                    SizedBox(height: 40.h),

                    SizedBox(
                      width: 240.w,
                      child: ButtonApp(
                        text: _isEditing ? 'حفظ التعديلات' : 'حفظ التصنيف',
                        isLoading: isProcessing,
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final newCategory = CategoryModel(
      id: widget.categoryToEdit?.id ?? '',
      name: _nameController.text.trim(),
      level: (_isSubCategory && _selectedParent != null) ? (_selectedParent!.level + 1) : 1,
      parentId: _isSubCategory ? _selectedParent?.id : null,
      sortOrder: widget.categoryToEdit?.sortOrder ?? 1,
      productCount: widget.categoryToEdit?.productCount ?? 0,
    );

    if (_isEditing) {
      ref.read(categoriesNotifierProvider.notifier).updateCategory(newCategory);
    } else {
      ref.read(categoriesNotifierProvider.notifier).addCategory(newCategory);
    }
  }
}