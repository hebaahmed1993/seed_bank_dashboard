import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../dashboard/presentation/pages/widgets/stat_card_widget.dart';
import '../../providers/statistics_provider.dart';

class StatisticsSectionWidget extends ConsumerWidget {
  const StatisticsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsNotifierProvider);

    if (state.fetchStatus == RequestStatus.loading) {
      return const CustomLoadingIndicator();
    }

    if (state.fetchStatus == RequestStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'حدث خطأ أثناء جلب الإحصائيات',
          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14.sp),
        ),
      );
    }

    final stats = state.statistics;

    // الإحصائيات الشاملة (All-Time) والنشطة
    final statItems = [
      _StatConfig("إجمالي الطلبات", '${stats.totalOrders}', Icons.receipt_long_outlined, Colors.blueGrey),
      _StatConfig("الطلبات النشطة", '${stats.activeOrders}', Icons.local_shipping_outlined, Colors.orange),
      _StatConfig("إجمالي المنتجات", '${stats.totalProducts}', Icons.grass, Colors.green),
      _StatConfig("إجمالي الموردين", '${stats.totalSuppliers}', Icons.storefront, Colors.purple),
      _StatConfig("المستخدمين", '${stats.totalUsers}', Icons.people_outline, Colors.blue),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statItems.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280.w,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final item = statItems[index];

        return StatCardWidget(
          title: item.title,
          value: item.value,
          icon: item.icon,
          color: item.color, // سيأخذ لون الأيقونة والخلفية المخصصة للبطاقة
        );
      },
    );
  }
}

class _StatConfig {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _StatConfig(this.title, this.value, this.icon, this.color);
}