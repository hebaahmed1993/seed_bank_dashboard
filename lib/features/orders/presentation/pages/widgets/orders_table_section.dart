import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_error_messages.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/widgets/custom_print_button.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_pagination_controls.dart';
import '../../../../../core/widgets/custom_view_button.dart';
import '../../../data/models/order_status_model.dart';
import '../../providers/orders_provider.dart';
import 'order_details_dialog.dart';

class OrdersTableSection extends ConsumerWidget {
  const OrdersTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ordersNotifierProvider);
    final pagination = state.ordersPagination;
    final orders = pagination.items;
    final currentPage = pagination.currentPage;

    // 🎯 1. جلب الـ limit بنفس طريقة الموردين لحساب عمود التسلسل (#) بشكل صحيح
    final limit = ref.read(ordersNotifierProvider.notifier).limit;

    final statusesAsync = ref.watch(orderStatusesStreamProvider);
    final statuses = statusesAsync.value ?? [];

    final isLoading = state.fetchOrdersStatus == RequestStatus.loading;

    // عرض خطأ عام للمستخدم في حال فشل الجلب وكانت الشاشة فارغة تماماً
    if (state.fetchOrdersStatus == RequestStatus.error && orders.isEmpty) {
      return Center(
        child: Text(
          AppErrorMessages.initialFetchError,
          style: TextStyle(color: AppColors.error, fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 🎯 2. توحيد الأعمدة مع الموردين (إضافة عمود التسلسل #)
    final columns = [
      const DataColumn(label: Text("#")),
      DataColumn(label: Text(l10n.orderNumberColumn)),
      DataColumn(label: Text('المستخدم')),
      DataColumn(label: Text(l10n.orderDateTimeColumn)),
      DataColumn(label: Text(l10n.orderValueColumn)),
      DataColumn(label: Text(l10n.orderStatusColumn)),
      DataColumn(label: Text(l10n.actionsColumn)),
    ];

    // 🎯 3. دمج حلقة التكرار بشكل صحيح (بدون تداخل)
    final rows = orders.asMap().entries.map((entry) {
      final index = (currentPage - 1) * limit + (entry.key + 1);
      final order = entry.value;

      final formattedDate = DateFormat('yyyy-MM-dd - hh:mm a').format(order.createdAt);

      final currentStatus = statuses.firstWhere(
            (s) => s.statusId == order.statusId,
        orElse: () => OrderStatusModel(
          statusId: order.statusId,
          nameAr: order.statusId == 'pending' ? l10n.pendingApproval : order.statusId,
          nameEn: order.statusId,
          description: '',
          colorHex: '#808080', // رمادي كقيمة افتراضية
          isActive: true,
          name: '',
        ),
      );

      // 🎯 4. بديل دالة _parseHexColor الملغاة (سطر واحد نظيف وآمن)
      final statusColor = Color(int.tryParse(currentStatus.colorHex.replaceFirst('#', '0xFF')) ?? AppColors.success.toARGB32());

      return DataRow(
        cells: [
          DataCell(Text('$index')), // عمود التسلسل الجديد
          DataCell(
            SelectableText(
              '#${order.orderId.substring(0, 6).toUpperCase()}',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.info, fontSize: 13.sp),
            ),
          ),
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(order.userName),
                Text(order.userPhone, ),
              ],
            ),
          ),
          DataCell(Text(formattedDate)),
          DataCell(
            Text(
              '${order.grandTotal.toStringAsFixed(0)} ${l10n.currency}',
            ),
          ),
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                currentStatus.nameAr,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => OrderDetailsDialog(
                        order: order,
                        statuses: statuses,
                      ),
                    );
                  },
                ),

                CustomPrintButton(
                  onPressed: () {
                    // TODO: إضافة كود توليد وطباعة ملف PDF لاحقاً
                  },
                ),
              ],
            ),
          ),        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomTable(
            columns: columns,
            rows: rows,
            isLoading: isLoading && orders.isEmpty,
            emptyMessage: l10n.noOrdersRegistered,
          ),
        ),
        CustomPaginationControls(
          currentPage: currentPage,
          hasNextPage: pagination.hasNextPage,
          isLoadingPage: isLoading,
          onPreviousPressed: () {
            if (!isLoading && pagination.hasPreviousPage) {
              ref.read(ordersNotifierProvider.notifier).goToPreviousPage();
            }
          },
          onNextPressed: () {
            if (!isLoading && pagination.hasNextPage) {
              ref.read(ordersNotifierProvider.notifier).goToNextPage();
            }
          },
        ),
      ],
    );
  }
}