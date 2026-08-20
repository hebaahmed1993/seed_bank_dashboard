import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_error_messages.dart';
import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_pagination_controls.dart';
import '../../../../../core/widgets/custom_edit_button.dart';
import '../../../../../core/widgets/custom_switch.dart';
import '../../../data/models/toggle_user_block_params_model.dart';
import '../../providers/users_provider.dart';
import 'user_form_dialog.dart';

class UsersTableSection extends ConsumerWidget {
  const UsersTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(usersNotifierProvider);
    final pagination = state.usersPagination;
    final users = pagination.items;
    final currentPage = pagination.currentPage;
    final limit = ref.read(usersNotifierProvider.notifier).limit;

    final isLoading = state.fetchUsersStatus == RequestStatus.loading;

    // 1. عرض رسالة الخطأ عند فشل الجلب وكانت القائمة فارغة
    if (state.fetchUsersStatus == RequestStatus.error && users.isEmpty) {
      return Center(
        child: Text(
          AppErrorMessages.initialFetchError,
        ),
      );
    }

    // 2. بناء أعمدة الجدول
    final columns = [
      const DataColumn(label: Text("#")),
      DataColumn(label: Text(l10n.userColumn)),
      DataColumn(label: Text(l10n.phoneColumn)),
      DataColumn(label: Text(l10n.cityColumn)),
      const DataColumn(label: Text("الحظر / التفعيل")),
      DataColumn(label: Text(l10n.actionsColumn)),
    ];

    // 3. بناء صفوف الجدول
    final rows = users.asMap().entries.map((entry) {
      final index = (currentPage - 1) * limit + (entry.key + 1);
      final user = entry.value;

      return DataRow(
        cells: [
          DataCell(Text('$index')),
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,

                ),
                Text(
                  user.email,

                ),
              ],
            ),
          ),
          DataCell(Text(user.phone)),
          DataCell(Text(user.cityName)),

          // استخدام CustomSwitch للحظر / إلغاء الحظر مباشرة من الجدول
          DataCell(
            CustomSwitch(
              value: !user.isBlocked,
              onChanged: (val) {
                final params = ToggleUserBlockParams(
                  userId: user.uid,
                  isBlocked: !val,
                );
                ref.read(usersNotifierProvider.notifier).toggleUserBlockStatus(params);
              },
            ),
          ),

          // زر التعديل الموحد CustomEditButton
          DataCell(
            CustomEditButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => UserFormDialog(user: user),
                );
              },
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4. الجدول الموحد
        Expanded(
          child: CustomTable(
            columns: columns,
            rows: rows,
            isLoading: isLoading && users.isEmpty,
            emptyMessage: l10n.noMatchingUsers,
          ),
        ),

        // 5. أزرار التنقل الموحدة
        CustomPaginationControls(
          currentPage: currentPage,
          hasNextPage: pagination.hasNextPage,
          isLoadingPage: isLoading,
          onPreviousPressed: () {
            if (!isLoading && pagination.hasPreviousPage) {
              ref.read(usersNotifierProvider.notifier).goToPreviousPage();
            }
          },
          onNextPressed: () {
            if (!isLoading && pagination.hasNextPage) {
              ref.read(usersNotifierProvider.notifier).goToNextPage();
            }
          },
        ),
      ],
    );
  }
}