import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/button_app.dart';
import 'add_edit_section_dialog.dart';

class HomeSectionsHeaderWidget extends StatelessWidget {
  const HomeSectionsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          'أقسام الصفحة الرئيسية',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        ButtonApp(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AddEditSectionDialog(),
            );
          },
          text: 'إضافة قسم جديد',
        ),
      ],
    );
  }
}