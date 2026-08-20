import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSubmitted; // 🎯 1. إضافة خاصية onSubmitted
  final List<Widget>? filterWidgets;
  final Widget? trailingWidget;

  const CustomFilterBar({
    super.key,
    required this.searchController,
    required this.searchHint,
    this.onSearchChanged,
    this.onSubmitted, // 🎯
    this.filterWidgets,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. عرض الفلاتر الإضافية إن وجدت (مثل فلاتر الحالة أو المدينة)
        if (filterWidgets != null && filterWidgets!.isNotEmpty) ...[
          ...filterWidgets!.expand((widget) => [widget, SizedBox(width: 12.w)]),
        ] else if (trailingWidget != null) ...[
          trailingWidget!,
          SizedBox(width: 12.w),
        ],

        // 2. مربع البحث المطاطي ليأخذ باقي مساحة السطر بمرونة تامة
        Expanded(
          child: CustomSearchBar(
            controller: searchController,
            hintText: searchHint,
            onChanged: onSearchChanged,
            onSubmitted: onSubmitted, // 🎯 تمريرها لمربع البحث
          ),
        ),
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted; // 🎯 2. إضافة خاصية onSubmitted

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted, // 🎯
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted, // 🎯 ربط الحدث بالـ TextField
      textInputAction: TextInputAction.search, // 🎯 تحويل زر الـ Enter في الكيبورد لرمز "بحث"
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          size: 20.r,
        ),
        fillColor: colorScheme.surface,
        filled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}