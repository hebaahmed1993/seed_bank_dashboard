import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seed_bank_dashboard/features/orders/presentation/pages/widgets/order_status_dropdown.dart';

import '../../../../../core/enums/pagination_action.dart';
import '../../../../../core/widgets/custom_search_bar.dart';
import '../../../../../core/widgets/custom_date_range_filter.dart';
import '../../../../locations/presentation/pages/widgets/cities/cities_dropdown_filter.dart';
import '../../providers/orders_provider.dart';

class OrdersFilterSection extends ConsumerStatefulWidget {
  const OrdersFilterSection({super.key});

  @override
  ConsumerState<OrdersFilterSection> createState() => _OrdersFilterSectionState();
}

class _OrdersFilterSectionState extends ConsumerState<OrdersFilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    ref.read(orderSearchQueryProvider.notifier).state = query.trim();
    ref.read(ordersNotifierProvider.notifier).fetchPage(
      action: PaginationAction.refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedStatus = ref.watch(orderStatusFilterProvider);
    final selectedCity = ref.watch(orderCityFilterProvider);

    // قراءة التواريخ
    final startDate = ref.watch(orderStartDateProvider);
    final endDate = ref.watch(orderEndDateProvider);

// استبدلي عمود الفلاتر (Column) بالكامل في build بهذا الكود:

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 👈 يسمح بالتمرير الأفقي عند تصغير الشاشة
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 900 ? MediaQuery.of(context).size.width - 300 : 900, // ضمان عرض كافٍ للفلاتر
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 الصف الأول: البحث، الحالة، والمدينة
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFilterBar(
                    searchController: _searchController,
                    searchHint: 'بحث باسم العميل أو رقم الهاتف (اضغط Enter)...',
                    onSubmitted: (value) => _executeSearch(value),
                    onSearchChanged: (value) {
                      if (value.isEmpty && ref.read(orderSearchQueryProvider).isNotEmpty) {
                        _executeSearch('');
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  flex: 1,
                  child: OrderStatusDropdown(
                    selectedValue: selectedStatus,
                    onChanged: (value) {
                      if (value != null && value != selectedStatus) {
                        ref.read(orderStatusFilterProvider.notifier).state = value;
                        ref.read(ordersNotifierProvider.notifier).fetchPage(action: PaginationAction.refresh);
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  flex: 1,
                  child: CitiesDropdownFilter(
                    selectedValue: selectedCity,
                    onChanged: (value) {
                      ref.read(orderCityFilterProvider.notifier).state = value;
                      ref.read(ordersNotifierProvider.notifier).fetchPage(action: PaginationAction.refresh);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 🎯 الصف الثاني: التواريخ المدمجة
            Row(
              children: [
                SizedBox(
                  width: 450.w, // تحديد عرض ثابت لمنع التقلص الزائد
                  child: CustomDateRangeFilter(
                    startDate: startDate,
                    endDate: endDate,
                    onChanged: (newStart, newEnd) {
                      ref.read(orderStartDateProvider.notifier).state = newStart;
                      ref.read(orderEndDateProvider.notifier).state = newEnd;
                      ref.read(ordersNotifierProvider.notifier).fetchPage(action: PaginationAction.refresh);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );  }
}