import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🎯 1. إضافة استيراد ملف رسائل الأخطاء القياسي
import '../../../../../core/constants/app_error_messages.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/custom_pagination_controls.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_view_button.dart';
import '../../../../../core/widgets/custom_edit_button.dart';
import '../../../../../core/widgets/custom_delete_button.dart';
import '../../../data/models/product_model.dart';
import '../../providers/products_provider.dart';
import 'product_form_dialog.dart';

class ProductsTableSection extends ConsumerWidget {
  const ProductsTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsNotifierProvider);
    final pagination = state.pagination;
    final products = pagination.items;
    final currentPage = pagination.currentPage;
    final isLoading = state.fetchStatus == RequestStatus.loading;

    // جلب الـ limit لحساب عمود التسلسل بشكل صحيح
    final limit = ref.read(productsNotifierProvider.notifier).limit;

    ref.listen(productsNotifierProvider, (previous, next) {
      if (next.deleteStatus != previous?.deleteStatus) {
        if (next.deleteStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: "تم حذف المنتج بنجاح",
          );
        } else if (next.deleteStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? "حدث خطأ أثناء حذف المنتج",
          );
        }
      }
    });

    // 🎯 2. إضافة شرط التحقق من الخطأ (مطابق تماماً لما في الطلبات والموردين)
    if (state.fetchStatus == RequestStatus.error && products.isEmpty) {
      return Center(
        child: Text(
          AppErrorMessages.initialFetchError,
          style: TextStyle(color: AppColors.error, fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      );
    }

    final columns = [
      const DataColumn(label: Text("#")), // عمود الترقيم
      const DataColumn(label: Text("الاسم")),
      // const DataColumn(label: Text("الموسم")), // 🎯 تم تعليق عمود الموسم
      const DataColumn(label: Text("السعر")),
      const DataColumn(label: Text("المخزون")),
      const DataColumn(label: Text("العمليات")),
    ];

    final rows = products.asMap().entries.map((entry) {
      // 🎯 حساب التسلسل الديناميكي
      final index = (currentPage - 1) * limit + (entry.key + 1);
      final product = entry.value;

      final hasStock = product.stockQuantity > 0;
      final isLowStock = product.stockQuantity <= product.lowStockThreshold;

      // 🎯 تم تعليق حساب تسمية الموسم لأنه لم يعد معروضاً
      /*
      String seasonLabel = product.season;
      if (product.season == 'spring') seasonLabel = 'الربيع';
      if (product.season == 'summer') seasonLabel = 'الصيف';
      if (product.season == 'autumn') seasonLabel = 'الخريف';
      if (product.season == 'winter') seasonLabel = 'الشتاء';
      if (product.season == 'all') seasonLabel = 'طوال العام';
      */

      return DataRow(
        cells: [
          DataCell(Text('$index')), // خلية الترقيم
          DataCell(
            Text(
              product.name,
            ),
          ),
          // DataCell(Text(seasonLabel)), // 🎯 تم تعليق خلية الموسم
          DataCell(Text("${product.price.toStringAsFixed(2)} د.ل")),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: !hasStock
                    ? AppColors.error.withValues(alpha: 0.1)
                    : isLowStock
                    ? AppColors.warning.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                "${product.stockQuantity}",
                style: TextStyle(
                  color: !hasStock
                      ? AppColors.error
                      : isLowStock
                      ? AppColors.warning
                      : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر العرض
                CustomViewButton(
                  onPressed: () {
                    // TODO: إضافة نافذة عرض تفاصيل المنتج مستقبلاً
                  },
                ),
                // زر التعديل
                CustomEditButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ProductFormDialog(productToEdit: product),
                    );
                  },
                ),
                // زر الحذف
                CustomDeleteButton(
                  onPressed: () {
                  _showDeleteConfirmationDialog(context, ref, product);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomTable(
            columns: columns,
            rows: rows,
            isLoading: isLoading && products.isEmpty,
            emptyMessage: "لا توجد منتجات مضافة حالياً",
          ),
        ),
        SizedBox(height: 16.h),
        CustomPaginationControls(
          currentPage: pagination.currentPage,
          hasNextPage: pagination.hasNextPage,
          isLoadingPage: isLoading,
          onPreviousPressed: () => ref.read(productsNotifierProvider.notifier).goToPreviousPage(),
          onNextPressed: () => ref.read(productsNotifierProvider.notifier).goToNextPage(),
        ),
      ],
    );
  }

void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, ProductModel product) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        content: Text(
          'هل أنت متأكد من حذف المنتج "${product.name}"؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(productsNotifierProvider.notifier).deleteProduct(product.id, product.categoryId);
            },
            child: const Text('حذف'),
          ),
        ],
      );
    },
  );
}
}
