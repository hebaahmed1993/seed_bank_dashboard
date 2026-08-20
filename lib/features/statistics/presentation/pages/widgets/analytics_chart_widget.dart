import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/statistics_provider.dart';

class AnalyticsSectionWidget extends ConsumerWidget {
  const AnalyticsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsNotifierProvider);
    final stats = state.statistics;
    final theme = Theme.of(context); // استخدام الثيم لتوحيد الألوان

    // حساب إجمالي الحركة لهذا الشهر (النشطة + المسلمة + الملغية)
    final monthlyWorkload = stats.activeOrders + stats.monthlyCompletedOrders + stats.monthlyCancelledOrders;

    double getPercentage(int value) {
      if (monthlyWorkload == 0) return 0.0;
      return (value / monthlyWorkload).clamp(0.0, 1.0);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.cardColor, // لون البطاقة من الثيم (أبيض غالباً)
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مؤشرات الأداء (هذا الشهر)',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color ?? Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'أداء الشهر الحالي',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // القسم الأيمن: مؤشرات توزيع حالة الطلبات (الخاصة بالشهر)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'توزيع حالات الطلبات الحالية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color ?? Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildProgressBarItem(
                      label: 'الطلبات النشطة (قيد المعالجة)',
                      value: stats.activeOrders,
                      percentage: getPercentage(stats.activeOrders),
                      color: Colors.orange,
                    ),
                    SizedBox(height: 12.h),
                    _buildProgressBarItem(
                      label: 'تم التسليم بنجاح (هذا الشهر)',
                      value: stats.monthlyCompletedOrders,
                      percentage: getPercentage(stats.monthlyCompletedOrders),
                      color: Colors.teal,
                    ),
                    SizedBox(height: 12.h),
                    _buildProgressBarItem(
                      label: 'الطلبات الملغية (هذا الشهر)',
                      value: stats.monthlyCancelledOrders,
                      percentage: getPercentage(stats.monthlyCancelledOrders),
                      color: theme.colorScheme.error, // لون الخطأ من الثيم
                    ),
                  ],
                ),
              ),
              SizedBox(width: 32.w),

              // القسم الأيسر: ملخص النشاط الشهري
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor, // توافق مع خلفية التطبيق
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص نشاط الشهر',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyMedium?.color ?? Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSummaryRow(
                        title: 'الطلبات التي تم تسليمها بنجاح',
                        value: '${stats.monthlyCompletedOrders}',
                        icon: Icons.check_circle_outline,
                        color: Colors.teal,
                      ),
                      Divider(height: 24.h, color: theme.dividerColor),
                      _buildSummaryRow(
                        title: 'الطلبات الملغية',
                        value: '${stats.monthlyCancelledOrders}',
                        icon: Icons.cancel_outlined,
                        color: theme.colorScheme.error,
                      ),
                      Divider(height: 24.h, color: theme.dividerColor),
                      _buildSummaryRow(
                        title: 'إجمالي طلبات الشهر',
                        value: '$monthlyWorkload',
                        icon: Icons.analytics_outlined,
                        color: theme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarItem({
    required String label,
    required int value,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.black87), // تم إصلاح خطأ الألوان هنا
            ),
            Text(
              '$value (${(percentage * 100).toStringAsFixed(1)}%)',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}