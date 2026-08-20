import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarHeaderWidget extends StatelessWidget {
  final String platformTitle;

  const SidebarHeaderWidget({
    super.key,
    required this.platformTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // // محاكاة للصورة الشخصية في التصميم
          // CircleAvatar(
          //   radius: 40.r,
          //   backgroundColor: Colors.white.withValues(alpha: 0.1),
          //   child: Icon(Icons.person_outline, size: 40.sp, color: Colors.white),
          // ),
          // SizedBox(height: 16.h),
          Text(
            platformTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white, // نص أبيض للتباين
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'admin@seedbank.com',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}