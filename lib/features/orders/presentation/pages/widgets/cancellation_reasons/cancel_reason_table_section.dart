import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/custom_table.dart';
import '../../../../../../core/widgets/custom_switch.dart';
import '../../../providers/orders_provider.dart';

class CancelReasonTableSection extends ConsumerWidget {
  const CancelReasonTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final cancelReasonsAsync = ref.watch(cancelReasonsStreamProvider);
    final ordersState = ref.watch(ordersNotifierProvider);

    // 🎯 الاستماع لحالة تغيير التفعيل لعرض الأخطاء
    ref.listen(ordersNotifierProvider, (previous, next) {
      if (previous?.toggleCancelReasonStatus != next.toggleCancelReasonStatus) {
        if (next.toggleCancelReasonStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return cancelReasonsAsync.when(
      data: (reasonsList) {
        final columns = [
          DataColumn(label: Text(l10n.reasonColumn)),
          DataColumn(label: Text(l10n.statusColumn)),
          DataColumn(label: Text(l10n.actionsColumn)),
        ];

        final rows = List<DataRow>.generate(
          reasonsList.length,
              (index) {
            final reason = reasonsList[index];
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    reason.reasonAr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                DataCell(
                  Text(
                    reason.isActive ? l10n.activeStatus : l10n.disabledStatus,
                    style: TextStyle(
                      color: reason.isActive
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                DataCell(
                  CustomSwitch(
                    value: reason.isActive,
                    onChanged: (newValue) {
                      ref.read(ordersNotifierProvider.notifier).toggleCancelReasonStatus(
                        reasonId: reason.reasonId,
                        isActive: newValue,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );

        return CustomTable(
          columns: columns,
          rows: rows,
          isLoading: ordersState.toggleCancelReasonStatus == RequestStatus.loading,
          emptyMessage: l10n.noRegisteredReasons,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.errorLoadingReasons(error.toString()),
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
