import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_loading_indicator.dart';

class ButtonApp extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const ButtonApp({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // 🎯 الاعتماد على ألوان الثيم النشط
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
        height: 24.h,
        width: 24.h,
        child: CustomLoadingIndicator(
          color: theme.colorScheme.onPrimary,
          strokeWidth: 2.5,
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
      child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
    );
  }
}