import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_sections_header_widget.dart';
import 'home_sections_table_section.dart';


class HomeSectionsListView extends StatelessWidget {
  const HomeSectionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionsHeaderWidget(),
          SizedBox(height: 24.h),



          const Expanded(
            child: HomeSectionsTableSection(),
          ),
        ],
      ),


    );
  }
}