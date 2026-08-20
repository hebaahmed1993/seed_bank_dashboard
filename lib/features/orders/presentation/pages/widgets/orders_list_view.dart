import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'orders_filter_section.dart';
import 'orders_header_widget.dart';
import 'orders_table_section.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الترويسة (Header)
          OrdersHeaderWidget(),
          SizedBox(height: 24.h),

          // 2. الفلتر والبحث (Filters & Search)
          const OrdersFilterSection(),
          SizedBox(height: 16.h),

          // 3. جدول البيانات
          const Expanded(
            child: OrdersTableSection(),
          ),
        ],
      ),
    );
  }
}