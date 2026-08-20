import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/staff_header_widget.dart';
import 'widgets/staff_table_section.dart';

class StaffPermissionsTab extends StatelessWidget {
  const StaffPermissionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("staff_permissions_tab"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StaffHeaderWidget(),
        SizedBox(height: 24.h),

        const Expanded(
          child: StaffTableSection(),
        ),
      ],
    );
  }
}