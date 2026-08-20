import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/button_app.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final VoidCallback onAddNewCategory;

  const CategoryHeaderWidget({
    super.key,
    required this.onAddNewCategory,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'إدارة التصنيفات',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        ButtonApp(
          text: 'إضافة تصنيف جديد',
          onPressed: onAddNewCategory,
        ),
      ],
    );
  }
}