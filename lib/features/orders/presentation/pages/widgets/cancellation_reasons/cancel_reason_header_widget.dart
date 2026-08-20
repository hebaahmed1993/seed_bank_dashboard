import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/button_app.dart';
import 'add_cancel_reason_dialog.dart';

class CancelReasonHeaderWidget extends StatelessWidget {
  const CancelReasonHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            l10n.manageCancelReasonsTitle,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        ButtonApp(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AddCancelReasonDialog(),
            );
          },
          text: l10n.addNewCancelReason,
        ),
      ],
    );
  }
}