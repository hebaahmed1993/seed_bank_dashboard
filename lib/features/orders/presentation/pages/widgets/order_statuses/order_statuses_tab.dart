import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'order_status_header_widget.dart';
import 'order_status_table_section.dart';

class OrderStatusesTab extends StatelessWidget {
  const OrderStatusesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("order_statuses_tab"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الترويسة وزر الإضافة
        const OrderStatusHeaderWidget(),
        SizedBox(height: 24.h),

        // 2. الجدول والبيانات
        const Expanded(
          child: OrderStatusTableSection(),
        ),
      ],
    );
  }
}