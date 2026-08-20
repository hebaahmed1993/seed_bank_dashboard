import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🎯 إضافة مكتبة ScreenUtil

import '../../../../core/enums/request_status.dart';
import '../../../../core/theme/theme/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../data/models/category_model.dart';
import '../providers/categories_provider.dart';
import '../providers/categories_state.dart';
import '../widgets/category_header_widget.dart';
import 'category_form_view.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  bool _showForm = false;
  CategoryModel? _categoryToEdit;

  void _toggleForm([CategoryModel? category]) {
    setState(() {
      _categoryToEdit = category;
      _showForm = !_showForm;
    });
  }

  void _handleDelete(CategoryModel category, String categoryName) {
    if (category.productCount > 0) {
      CustomSnackBar.showError(
        context: context,
        message: 'عذراً، لا يمكن حذف تصنيف يحتوي على منتجات',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        content: Text(
          'هل أنت متأكد من حذف التصنيف "$categoryName"؟',
          style: TextStyle(fontSize: 14.sp),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(categoriesNotifierProvider.notifier).deleteCategory(category);
            },
            child: Text(
              'حذف',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة حالة الحذف
    ref.listen<CategoriesState>(categoriesNotifierProvider, (prev, next) {
      if (prev?.deleteCategoryStatus != next.deleteCategoryStatus) {
        if (next.deleteCategoryStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: 'تم حذف التصنيف بنجاح',
          );
          ref.read(categoriesNotifierProvider.notifier).resetDeleteStatus();
        } else if (next.deleteCategoryStatus == RequestStatus.failure) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? 'فشل حذف التصنيف',
          );
        }
      }
    });

    if (_showForm) {
      return CategoryFormView(
        categoryToEdit: _categoryToEdit,
        onCancel: () => _toggleForm(null),
      );
    }

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryHeaderWidget(
            onAddNewCategory: () => _toggleForm(null),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: categoriesAsync.when(
              data: (categoryList) {
                if (categoryList.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد تصنيفات حالياً.',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: categoryList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220.w,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final category = categoryList[index];
                    final categoryName = category.name;
                    final canDelete = category.productCount == 0;

                    return GestureDetector(
                      onTap: () => _toggleForm(category),
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.folder_open_outlined,
                                    color: theme.primaryColor,
                                    size: 20.r,
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: canDelete ? AppColors.error : AppColors.textMuted,
                                    size: 20.r,
                                  ),
                                  tooltip: canDelete
                                      ? 'حذف التصنيف'
                                      : 'لا يمكن حذف تصنيف يحتوي على منتجات',
                                  onPressed: canDelete
                                      ? () => _handleDelete(category, categoryName)
                                      : null,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                categoryName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: AppColors.textPrimaryLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Flexible(
                              child: Text(
                                'عدد المنتجات: ${category.productCount}',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'خطأ: $err',
                  style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}