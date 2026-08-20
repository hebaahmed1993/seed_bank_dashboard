





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../data/models/cancel_reason_model.dart';
import '../../../data/models/order_model.dart';
import '../../providers/orders_provider.dart';
import 'cancellation_reasons/add_cancel_reason_dialog.dart';

class CancelOrderDialog extends ConsumerStatefulWidget {
  final OrderModel order;
  const CancelOrderDialog({super.key, required this.order});

  @override
  ConsumerState<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends ConsumerState<CancelOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  CancelReasonModel? _selectedReason;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cancelReasonsAsync = ref.watch(cancelReasonsStreamProvider);
    final state = ref.watch(ordersNotifierProvider);
    final isLoading = state.updateOrderStatusStatus == RequestStatus.loading;

    // الاستماع لنجاح عملية الإلغاء لإغلاق النافذتين
    ref.listen(ordersNotifierProvider, (previous, next) {
      if (previous?.updateOrderStatusStatus != next.updateOrderStatusStatus) {
        if (next.updateOrderStatusStatus == RequestStatus.success) {
          Navigator.pop(context); // إغلاق CancelOrderDialog
          Navigator.pop(context); // إغلاق OrderDetailsDialog أيضاً
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.orderCancelledSuccess,
          );
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
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Text(l10n.cancelOrderAndReturnProducts),
          ],
        ),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cancelOrderConfirmation(
                    widget.order.orderId.substring(0, 6).toUpperCase(),
                  ),
                ),
                const SizedBox(height: 20),

                cancelReasonsAsync.when(
                  data: (reasonsList) {
                    final activeReasons = reasonsList.where((r) => r.isActive).toList();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownFormField<CancelReasonModel>(
                            labelText: l10n.actualCancelReason,
                            value: _selectedReason,
                            items: activeReasons.map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.reasonAr),
                            )).toList(),
                            onChanged: isLoading ? null : (val) => setState(() => _selectedReason = val),
                            validator: (val) => val == null ? l10n.selectCancelReasonValidator : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: AppColors.info,
                              size: 28,
                            ),
                            onPressed: isLoading ? null : () async {
                              await showDialog<bool>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => const AddCancelReasonDialog(),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (err, _) => Text(l10n.ordersError(err.toString()), style: const TextStyle(color: AppColors.error)),
                ),
                const SizedBox(height: 18),

                CustomTextFormField(
                  controller: _notesController,
                  labelText: l10n.additionalAdminNotes,
                  maxLines: 3,
                  enabled: !isLoading,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            child: Text(l10n.goBack),
          ),
          SizedBox(
            width: 200,
            child: ButtonApp(
              onPressed: isLoading ? null : () {
                if (!_formKey.currentState!.validate()) return;

                ref.read(ordersNotifierProvider.notifier).updateOrderStatus(
                  orderId: widget.order.orderId,
                  statusId: 'cancelled',
                  cancelReason: _selectedReason?.reasonAr ?? l10n.customerChangedMind,
                  notes: _notesController.text.trim(),
                );
              },
              text: l10n.confirmFinalCancellation,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}