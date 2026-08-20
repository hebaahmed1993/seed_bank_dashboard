import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/pagination_action.dart';
import '../../../../../core/enums/status_filter.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_search_bar.dart';

import '../../../../locations/presentation/pages/widgets/cities/cities_dropdown_filter.dart';
import '../../providers/users_provider.dart';

class UserFilterSection extends ConsumerStatefulWidget {
  const UserFilterSection({super.key});

  @override
  ConsumerState<UserFilterSection> createState() => _UserFilterSectionState();
}

class _UserFilterSectionState extends ConsumerState<UserFilterSection> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _executeSearch(String query) {
    ref.read(userSearchQueryProvider.notifier).state = query.trim();
    ref.read(usersNotifierProvider.notifier).fetchPage(
      action: PaginationAction.refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedStatus = ref.watch(userStatusFilterProvider);
    final selectedCity = ref.watch(userCityFilterProvider); // 👈 قراءة المدينة المحددة

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          // 1. حقل البحث
          Expanded(
            flex: 2,
            child: CustomFilterBar(
              searchController: _searchController,
              searchHint: 'بحث بالاسم / الهاتف (اضغط Enter)...',
              onSubmitted: (value) => _executeSearch(value),
              onSearchChanged: (value) {
                if (value.isEmpty && ref.read(userSearchQueryProvider).isNotEmpty) {
                  _executeSearch('');
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
                ref.read(userCityFilterProvider.notifier).state = value;
                ref.read(usersNotifierProvider.notifier).refreshWithFilters();
              },
            ),
          ),
          SizedBox(width: 16.w),

          Expanded(
            flex: 1,
            child: CustomDropdownFormField<StatusFilter>(
              value: selectedStatus,
              labelText: l10n.statusColumn,
              prefixIcon: Icons.filter_list_outlined,
              items: StatusFilter.values.map((filter) {
                return DropdownMenuItem<StatusFilter>(
                  value: filter,
                  child: Text(filter.label(l10n)),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null && newValue != selectedStatus) {
                  ref.read(userStatusFilterProvider.notifier).state = newValue;
                  ref.read(usersNotifierProvider.notifier).fetchPage(
                    action: PaginationAction.refresh,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}