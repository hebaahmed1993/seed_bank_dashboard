import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingPage;
  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;

  // 🎯 1. تم حذف onPageSelected لأنه لم يعد ضرورياً في Cursor Pagination
  const CustomPaginationControls({
    super.key,
    required this.currentPage,
    required this.hasNextPage,
    required this.isLoadingPage,
    this.onPreviousPressed,
    this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool canGoPrevious = currentPage > 1 && !isLoadingPage;
    final bool canGoNext = hasNextPage && !isLoadingPage;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // زر السهم السابق (<)
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 16.r,
              color: canGoPrevious ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            onPressed: canGoPrevious ? onPreviousPressed : null,
          ),
          SizedBox(width: 8.w),

          // 1. عرض رقم الصفحة السابقة إن وجد (قابل للنقر)
          if (currentPage > 1) ...[
            _buildPageButton(
              context: context,
              pageNumber: currentPage - 1,
              isSelected: false,
              // 🎯 2. ربط النقر على الرقم بدالة الرجوع للخلف مباشرة
              onTap: canGoPrevious ? onPreviousPressed : null,
            ),
            SizedBox(width: 8.w),
          ],

          // 2. عرض رقم الصفحة الحالي (مظلل أو دائرة تحميل)
          isLoadingPage
              ? SizedBox(
            width: 24.w,
            height: 24.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          )
              : _buildPageButton(
            context: context,
            pageNumber: currentPage,
            isSelected: true,
            onTap: null, // الصفحة الحالية لا تحتاج لنقر
          ),

          // 3. عرض رقم الصفحة التالية إن وجد (قابل للنقر)
          if (hasNextPage) ...[
            SizedBox(width: 8.w),
            _buildPageButton(
              context: context,
              pageNumber: currentPage + 1,
              isSelected: false,
              // 🎯 3. ربط النقر على الرقم بدالة التقدم للأمام مباشرة
              onTap: canGoNext ? onNextPressed : null,
            ),
          ],

          SizedBox(width: 8.w),
          // زر السهم اللاحق (>)
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.r,
              color: canGoNext ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            onPressed: canGoNext ? onNextPressed : null,
          ),
        ],
      ),
    );
  }

  // مكون مساعد لبناء أزرار الأرقام بشكل موحد
  Widget _buildPageButton({
    required BuildContext context,
    required int pageNumber,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? null
              : Border.all(color: colorScheme.onSurface.withValues(alpha: 0.2)),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}