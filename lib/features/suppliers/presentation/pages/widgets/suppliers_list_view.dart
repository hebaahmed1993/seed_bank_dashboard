import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'suppliers_filter_section.dart';
import 'suppliers_header_widget.dart';
import 'suppliers_table_section.dart';

class SuppliersListView extends StatelessWidget {
  const SuppliersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SuppliersHeaderWidget(),

          SizedBox(height: 24.h),

          // القسم الثاني: شريط البحث والفلاتر (معزول في مكون مستقل)
          const SuppliersFilterSection(),

          SizedBox(height: 16.h),

          // القسم الثالث: جدول البيانات
          const Expanded(
            child: SuppliersTableSection(),
          ),
        ],
      ),
    );
  }
}