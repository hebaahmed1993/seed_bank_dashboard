import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/toggle_user_block_params_model.dart';
import '../../providers/users_provider.dart';
import 'user_form_dialog.dart';

class UserActionButtons extends ConsumerWidget {
  final UserModel user;
  final AppLocalizations l10n;

  const UserActionButtons({
    super.key,
    required this.user,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // 1. زر التعديل
        IconButton(
          icon: Icon(Icons.edit_note, color: AppColors.info, size: 24.sp),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => UserFormDialog(user: user),
            );
          },
          tooltip: l10n.editDetails,
        ),

        // 2. زر الحظر / إلغاء الحظر (نظيف تماماً)
        IconButton(
          icon: Icon(
            user.isBlocked ? Icons.play_circle_fill : Icons.block_flipped,
            color: user.isBlocked ? AppColors.success : AppColors.error,
            size: 24.sp,
          ),
          onPressed: () {
            // 🎯 نرسل الطلب للـ Notifier فقط، والـ UI سيستمع للنتيجة من مكان آخر
            final params = ToggleUserBlockParams(
              userId: user.uid,
              isBlocked: !user.isBlocked,
            );
            ref.read(usersNotifierProvider.notifier).toggleUserBlockStatus(params);
          },
          tooltip: user.isBlocked ? l10n.unblockUserTooltip : l10n.blockUserTooltip,
        ),
      ],
    );
  }
}