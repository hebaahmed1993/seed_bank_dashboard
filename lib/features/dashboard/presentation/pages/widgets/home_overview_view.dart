import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../orders/presentation/widgets/recent_orders_section_widget.dart';
import '../../../../statistics/presentation/pages/widgets/analytics_chart_widget.dart';
import '../../../../statistics/presentation/pages/widgets/statistics_section_widget.dart';

class HomeOverviewView extends StatelessWidget {
  const HomeOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('home_overview'),
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatisticsSectionWidget(),

          SizedBox(height: 32.h),
          const AnalyticsSectionWidget(),


          SizedBox(height: 32.h),

          const RecentOrdersSectionWidget(),
        ],
      ),
    );
  }
}