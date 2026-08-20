import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/utils/custom_snackbar.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_switch.dart';
import '../../../../../core/widgets/custom_edit_button.dart';
import '../../providers/staff_provider.dart';
import 'add_edit_staff_dialog.dart';

class StaffTableSection extends ConsumerWidget {
  const StaffTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final staffAsync = ref.watch(staffStreamProvider);
    final accountTypesAsync = ref.watch(accountTypesStreamProvider);
    final staffState = ref.watch(staffNotifierProvider);

    // 🎯 الاستماع لعمليات الحظر/التفعيل
    ref.listen(staffNotifierProvider, (previous, next) {
      if (previous?.toggleStaffBlockStatus != next.toggleStaffBlockStatus) {
        if (next.toggleStaffBlockStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.statusUpdatedSuccess,
          );
        } else if (next.toggleStaffBlockStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return staffAsync.when(
      data: (staffList) {
        // ننتظر حتى تتوفر أنواع الحسابات لنتمكن من مطابقتها
        final accountTypesList = accountTypesAsync.value ?? [];

        final columns = [
          DataColumn(label: Text(l10n.nameColumn)),
          DataColumn(label: Text(l10n.emailColumn)),
          DataColumn(label: Text(l10n.roleColumn)),
          DataColumn(label: Text(l10n.statusColumn)),
          DataColumn(label: Text(l10n.actionsColumn)),
        ];

        final rows = List<DataRow>.generate(
          staffList.length,
              (index) {
            final staff = staffList[index];

            // 🎯 جلب اسم الصلاحية بناءً على المعرف
            final roleName = accountTypesList
                .where((role) => role.id == staff.accountTypeId)
                .map((role) => role.typeName.isNotEmpty ? role.typeName : role.name)
                .firstWhere((_) => true, orElse: () => staff.accountTypeId);

            final isActive = !staff.isBlocked;

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    staff.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(
                  Text(
                    staff.email,
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      roleName,
                      style: TextStyle(color: colorScheme.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    isActive ? l10n.activeStatus : l10n.blockedStatus,
                    style: TextStyle(
                      color: isActive ? colorScheme.primary : colorScheme.error,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSwitch(
                        value: isActive,
                        activeColor: colorScheme.primary,
                        //inactiveColor: colorScheme.error,
                        onChanged: (newValue) {
                          ref.read(staffNotifierProvider.notifier).toggleStaffBlock(
                            staffId: staff.id,
                            isBlocked: !newValue, // عكس القيمة لأننا نخزن isBlocked
                          );
                        },
                      ),
                      SizedBox(width: 8.w),
                      CustomEditButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AddEditStaffDialog(staffToEdit: staff),
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
          isLoading: staffState.toggleStaffBlockStatus == RequestStatus.loading,
          emptyMessage: l10n.noRegisteredAdmins,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.unexpectedError,
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}