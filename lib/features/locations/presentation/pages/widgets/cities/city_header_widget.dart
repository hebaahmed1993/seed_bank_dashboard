import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/button_app.dart';
import 'add_city_dialog.dart';

class CityHeaderWidget extends StatelessWidget {
  const CityHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.citiesManagementTitle,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface, // 🎯 استخدام لون الثيم
          ),
        ),
        ButtonApp(
          text: l10n.addNewCity,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AddCityDialog(),
            );
          },
        ),
      ],
    );
  }
}