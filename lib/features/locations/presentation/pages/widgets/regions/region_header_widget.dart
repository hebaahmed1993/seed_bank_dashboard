import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/button_app.dart';
import 'add_region_dialog.dart';

class RegionHeaderWidget extends StatelessWidget {
  const RegionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.regionsManagementTitle,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        ButtonApp(
          text: l10n.addNewRegion,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AddRegionDialog(),
            );
          },
        ),
      ],
    );
  }
}