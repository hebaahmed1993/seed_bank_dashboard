import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme/app_colors.dart';

class CustomDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const CustomDeleteButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'حذف',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20.sp),
      tooltip: tooltip,
      splashRadius: 20.r,
      onPressed: onPressed,
    );
  }
}