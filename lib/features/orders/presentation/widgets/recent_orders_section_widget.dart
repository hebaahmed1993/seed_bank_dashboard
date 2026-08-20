import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme/app_colors.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../core/widgets/custom_view_button.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_status_model.dart';
import '../pages/widgets/order_details_dialog.dart';
import '../providers/orders_provider.dart';

class RecentOrdersSectionWidget extends ConsumerWidget {
  const RecentOrdersSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recentOrdersAsync = ref.watch(recentProcessingOrdersStreamProvider);
    final statusesAsync = ref.watch(orderStatusesStreamProvider);
    final statuses = statusesAsync.value ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 🎯 رأس القسم (Header)
          // ==========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.sync_rounded,
                      color: colorScheme.primary,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أحدث الطلبات قيد المعالجة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'متابعة لحظية للطلبات الجاري تجهيزها',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 🎯 بادج البث المباشر (Live Indicator)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'تحديث لحظي',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ==========================================
          // 🎯 محتوى القائمة حسب حالة الـ Stream
          // ==========================================
          recentOrdersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildOrdersList(context, orders, statuses);
            },
            loading: () => SizedBox(
              height: 160.h,
              child: Center(
                child: CustomLoadingIndicator(color: colorScheme.primary),
              ),
            ),
            error: (error, stack) => Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'فشل تحميل الطلبات الحالية: $error',
                      style: TextStyle(color: AppColors.error, fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ——— قائمة الطلبات النشطة ——————————————————————————————
  Widget _buildOrdersList(
    BuildContext context,
    List<OrderModel> orders,
    List<OrderStatusModel> statuses,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (context, index) => Divider(
        height: 1.h,
        color: colorScheme.outlineVariant.withValues(alpha: 0.15),
      ),
      itemBuilder: (context, index) {
        final order = orders[index];
        final formattedDate = DateFormat(
          'yyyy-MM-dd - hh:mm a',
        ).format(order.createdAt);
        final shortOrderId =
            '#${order.orderId.substring(0, order.orderId.length > 6 ? 6 : order.orderId.length).toUpperCase()}';

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              // رمز الطلب
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: colorScheme.primary,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 14.w),

              // بيانات العميل والطلب
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          shortOrderId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: AppColors.info,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          order.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${order.userPhone} • $formattedDate',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // الإجمالي
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.grandTotal.toStringAsFixed(2)} د.أ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${order.items.length} منتجات',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // بادج الحالة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'قيد المعالجة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // زر التفاصيل
              CustomViewButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        OrderDetailsDialog(order: order, statuses: statuses),
                  );
                },
                tooltip: 'عرض تفاصيل الطلب',
              ),
            ],
          ),
        );
      },
    );
  }

  // ——— حالة عدم وجود طلبات قيد المعالجة ———————————————————
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48.r,
              color: Colors.green.shade600.withValues(alpha: 0.7),
            ),
            SizedBox(height: 12.h),
            Text(
              'لا توجد طلبات قيد المعالجة حالياً',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'جميع الطلبات تمت معالجتها وتسليمها بنجاح',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
