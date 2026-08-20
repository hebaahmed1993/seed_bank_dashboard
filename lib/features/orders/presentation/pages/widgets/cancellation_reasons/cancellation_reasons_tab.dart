import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cancel_reason_header_widget.dart';
import 'cancel_reason_table_section.dart';

class CancellationReasonsTab extends StatelessWidget {
  const CancellationReasonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الترويسة وزر الإضافة
        const CancelReasonHeaderWidget(),
        SizedBox(height: 24.h),

        // 2. الجدول والتنبيهات
        const Expanded(
          child: CancelReasonTableSection(),
        ),
      ],
    );
  }
}