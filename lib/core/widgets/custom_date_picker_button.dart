import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme/app_colors.dart';

class CustomDatePickerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const CustomDatePickerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // 🎯 استخدام Theme للحصول على اللون الديناميكي للزر
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        // استخدام اللون الأساسي من الثيم مع شفافية عند التحديد
        color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.transparent,
        border: Border.all(
          color: isSelected ? primaryColor : colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18.r,
                    // استخدام اللون الأساسي مع تغيير الشفافية
                    color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected ? primaryColor : colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // زر المسح (يظهر فقط إذا كان الزر محدداً)
          if (isSelected)
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(6.r),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.r,
                    // استخدام لون الخطأ الموحد من ملفات الثيم الخاصة بك
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}