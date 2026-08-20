import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final Color sidebarColor; // اللون الداكن للقائمة
  final Color mainBgColor;  // اللون الفاتح لخلفية المحتوى
  final VoidCallback onTap;

  const SidebarItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    required this.sidebarColor,
    required this.mainBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎯 1. عكس الألوان بذكاء:
    // إذا كان نشطاً -> النص يأخذ لون القائمة الداكن، والخلفية تأخذ اللون الفاتح للمحتوى.
    // إذا لم يكن نشطاً -> النص أبيض شفاف، والخلفية شفافة.
    final Color textColor = isActive ? sidebarColor : Colors.white70;
    final Color iconColor = isActive ? sidebarColor : Colors.white70;
    final Color bgColor = isActive ? mainBgColor : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // إبعاد العنصر عن الحافة اليمنى ليعطي مساحة للتدوير كما في التصميم
        margin: EdgeInsets.only(
          top: 4.h,
          bottom: 4.h,
          right: 16.w,
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: bgColor,
          // 🎯 2. الخدعة البصرية: الحواف اليمنى دائرية، واليسرى حادة لترتبط بالمحتوى
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(30.r),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}