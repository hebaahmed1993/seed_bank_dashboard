import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/custom_table.dart';
import '../../../../../../core/widgets/custom_switch.dart';
import '../../../../../../core/widgets/custom_edit_button.dart';
import '../../../providers/orders_provider.dart';
import 'add_edit_order_status_dialog.dart';

class OrderStatusTableSection extends ConsumerStatefulWidget {
  const OrderStatusTableSection({super.key});

  @override
  ConsumerState<OrderStatusTableSection> createState() => _OrderStatusTableSectionState();
}

class _OrderStatusTableSectionState extends ConsumerState<OrderStatusTableSection> {
  String? _lastToggledStatusName;
  bool? _lastToggleAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final orderStatusesAsync = ref.watch(orderStatusesStreamProvider);
    final ordersState = ref.watch(ordersNotifierProvider);

    // 🎯 الاستماع لحالة تغيير التفعيل لعرض الإشعارات
    ref.listen(ordersNotifierProvider, (previous, next) {
      if (previous?.toggleOrderStatusDetailsStatus != next.toggleOrderStatusDetailsStatus) {
        if (next.toggleOrderStatusDetailsStatus == RequestStatus.success) {
          final name = _lastToggledStatusName ?? '';
          final message = _lastToggleAction == true
              ? l10n.statusActivatedSuccess(name)
              : l10n.statusDeactivatedSuccess(name);
          CustomSnackBar.showSuccess(context: context, message: message);
        } else if (next.toggleOrderStatusDetailsStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return orderStatusesAsync.when(
      data: (statusesList) {
        final columns = [
          DataColumn(label: Text(l10n.statusNameColumn)),
          DataColumn(label: Text(l10n.statusDescriptionColumn)),
          DataColumn(label: Text(l10n.statusColorColumn)),
          DataColumn(label: Text(l10n.statusColumn)),
          DataColumn(label: Text(l10n.actionsColumn)),
        ];

        final rows = List<DataRow>.generate(
          statusesList.length,
              (index) {
            final status = statusesList[index];
            final Color statusColor = _parseColorHex(status.colorHex, colorScheme.primary);

            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        status.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      status.description,
                      style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface.withValues(alpha: 0.8)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        status.colorHex,
                        style: TextStyle(fontSize: 12.sp, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    status.isActive ? l10n.activeStatus : l10n.disabledStatus,
                    style: TextStyle(
                      color: status.isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSwitch(
                        value: status.isActive,
                        onChanged: (newValue) {
                          _lastToggledStatusName = status.name;
                          _lastToggleAction = newValue;
                          ref.read(ordersNotifierProvider.notifier).toggleOrderStatusDetails(
                            statusId: status.statusId,
                            isActive: newValue,
                          );
                        },
                      ),
                      SizedBox(width: 8.w),
                      CustomEditButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AddEditOrderStatusDialog(statusToEdit: status),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );

        return CustomTable(
          columns: columns,
          rows: rows,
          isLoading: ordersState.toggleOrderStatusDetailsStatus == RequestStatus.loading,
          emptyMessage: l10n.noRegisteredStatuses,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.errorLoadingStatuses(error.toString()),
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 🎯 استخراج اللون بشكل آمن مع Fallback للون الثيم الأساسي بدلاً من الأخضر
  Color _parseColorHex(String hex, Color fallbackColor) {
    try {
      final cleanHex = hex.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
    } catch (_) {}
    return fallbackColor;
  }
}