import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  // 🎯 المتغيرات الجديدة (اختيارية)
  final String? title;
  final String? subtitle;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.title,      // غير مطلوب (Not Required)
    this.subtitle,   // غير مطلوب (Not Required)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveActiveColor = activeColor ?? colorScheme.primary;

    // 1. تصميم المفتاح الأساسي (Switch)
    final switchWidget = Switch(
      value: value,
      activeColor: effectiveActiveColor,
      activeTrackColor: effectiveActiveColor.withValues(alpha: 0.25),
      inactiveThumbColor: colorScheme.outline,
      inactiveTrackColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      onChanged: onChanged,
    );

    // 2. إذا لم يتم تمرير عنوان، نعرض المفتاح منفرداً
    if (title == null) {
      return switchWidget;
    }

    // 3. إذا تم تمرير عنوان، نعرضه مع النصوص بشكل منسق
    return InkWell(
      onTap: () => onChanged(!value), // السطر بالكامل قابل للضغط
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // قسم النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface, // 🎯 اللون أصبح محايداً بدلاً من الأخضر
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6), // 🎯 لون فرعي رمادي
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // قسم المفتاح
            switchWidget,
          ],
        ),
      ),
    );
  }
}