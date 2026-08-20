import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/order_status_model.dart';
import '../../providers/orders_provider.dart';
import 'cancel_order_dialog.dart';

class OrderDetailsDialog extends ConsumerStatefulWidget {
  final OrderModel order;
  final List<OrderStatusModel> statuses;

  const OrderDetailsDialog({
    super.key,
    required this.order,
    required this.statuses,
  });

  @override
  ConsumerState<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends ConsumerState<OrderDetailsDialog> {
  String? _targetStatusName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final order = widget.order;
    final statuses = widget.statuses;

    ref.listen(ordersNotifierProvider, (previous, next) {
      if (previous?.updateOrderStatusStatus != next.updateOrderStatusStatus) {
        if (next.updateOrderStatusStatus == RequestStatus.success) {
          Navigator.pop(context);
          if (_targetStatusName != null) {
            CustomSnackBar.showSuccess(
              context: context,
              message: l10n.orderStatusUpdatedSuccess(_targetStatusName!),
            );
          }
        } else if (next.updateOrderStatusStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: Colors.white, // خلفية النافذة الأساسية
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. رأس النافذة (Header)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08), // لون خلفية ناعم جداً
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.orderDetailsTitle(
                          order.orderId.substring(0, 8).toUpperCase(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. بيانات العميل والتوصيل
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: l10n.clientData,
                              icon: Icons.person_outline,
                              children: [
                                Text(
                                  l10n.clientNameLabel(order.userName),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(l10n.clientPhoneLabel(order.userPhone)),
                                Text(
                                  l10n.clientUserIdLabel(order.userId),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              title: l10n.deliveryAndTimeData,
                              icon: Icons.local_shipping_outlined,
                              children: [
                                Text(
                                  l10n.deliveryAddressLabel(order.deliveryAddress),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  l10n.deliveryFeeLabel(order.deliveryFee.toStringAsFixed(0)),
                                ),
                                Text(
                                  l10n.orderTimeLabel(
                                    DateFormat('yyyy-MM-dd / hh:mm a').format(order.createdAt),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 3. المنتجات المطلوبة
                      Text(
                        l10n.requestedProducts,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // الجدول الخاص بك يوضع هنا
                      const SizedBox(height: 16),

                      // 4. ملخص الفاتورة
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 320,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.05), // خلفية خضراء شفافة جداً
                            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)), // حد ناعم
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l10n.totalProductsLabel),
                                  Text(
                                    '${order.totalPrice.toStringAsFixed(0)} ${l10n.currency}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l10n.deliveryCostLabel),
                                  Text(
                                    '${order.deliveryFee.toStringAsFixed(0)} ${l10n.currency}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(color: Colors.black12),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.grandTotalLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${order.grandTotal.toStringAsFixed(0)} ${l10n.currency}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 5. ملاحظات الإلغاء أو الإدارة
                      if (order.statusId == 'cancelled') ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.05), // خلفية حمراء شفافة
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)), // حد أحمر ناعم
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.cancellationInfoTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.cancelReasonLabel(order.cancelReason ?? l10n.noReasonSpecified),
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                              if (order.notes != null && order.notes!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  l10n.adminNotesLabel(order.notes!),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else if (order.notes != null && order.notes!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withValues(alpha: 0.05),
                            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.orderNotesLabel(order.notes!),
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Divider(color: Colors.black12),
                      const SizedBox(height: 16),

                      // 6. أزرار تحديث الحالة
                      Text(
                        l10n.updateOrderStatusTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusUpdateActions(context, order, statuses, l10n),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة بناء البطاقات (بيانات العميل والتوصيل) بتصميم نظيف
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // خلفية بيضاء
        border: Border.all(color: Colors.grey.shade300), // حدود رمادية خفيفة
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children.map(
                (w) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Cairo'), // توحيد لون وحجم النص
                child: w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateActions(
      BuildContext context,
      OrderModel order,
      List<OrderStatusModel> statuses,
      AppLocalizations l10n,
      ) {
    final notifierState = ref.watch(ordersNotifierProvider);
    final isLoading = notifierState.updateOrderStatusStatus == RequestStatus.loading;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: statuses.map((status) {
        // إخفاء الزر إذا كانت الحالة هي الحالة الحالية للطلب
        if (status.statusId == order.statusId) return const SizedBox.shrink();

        return SizedBox(
          width: 150,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () => _handleStatusChange(context, order, status, l10n),
            text: status.nameAr,
            isLoading: isLoading,
          ),
        );
      }).toList(),
    );
  }

  void _handleStatusChange(
      BuildContext context,
      OrderModel order,
      OrderStatusModel targetStatus,
      AppLocalizations l10n,
      ) {
    if (targetStatus.statusId == 'cancelled') {
      _showCancellationDialog(context, order, l10n);
    } else {
      _targetStatusName = targetStatus.nameAr;
      ref.read(ordersNotifierProvider.notifier).updateOrderStatus(
        orderId: order.orderId,
        statusId: targetStatus.statusId,
      );
    }
  }

  void _showCancellationDialog(
      BuildContext context,
      OrderModel order,
      AppLocalizations l10n,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CancelOrderDialog(order: order),
    );
  }
}