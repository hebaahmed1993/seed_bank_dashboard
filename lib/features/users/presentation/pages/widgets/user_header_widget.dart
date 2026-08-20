import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seed_bank_dashboard/features/users/presentation/pages/widgets/user_form_dialog.dart';

import '../../../../../core/widgets/button_app.dart';

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة المستخدمين",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        ButtonApp(
          text: "إضافة مستخدم جديد",
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const UserFormDialog(),
          ),
        ),
      ],
    );
  }
}