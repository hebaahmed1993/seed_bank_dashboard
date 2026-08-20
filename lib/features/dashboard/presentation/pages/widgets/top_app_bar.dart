import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme/app_colors.dart';

class TopAppBarWidget extends StatelessWidget {
  final String welcomeMessage;
  final double? height;
  final Color backgroundColor;

  const TopAppBarWidget({
    super.key,
    required this.welcomeMessage,
    required this.backgroundColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // 🎯 قراءة اللون الرئيسي الديناميكي بدلاً من اللون الثابت
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      height: height ?? 60.h,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1), // 🎯 شفافية 10% من اللون الأساسي
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.wb_sunny, size: 18.sp, color: primaryColor), // 🎯
                SizedBox(width: 8.w),
                Icon(Icons.nightlight_round, size: 18.sp, color: AppColors.textMuted), // 🎯 رمادي موحد
              ],
            ),
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, size: 24.sp, color: primaryColor), // 🎯
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}