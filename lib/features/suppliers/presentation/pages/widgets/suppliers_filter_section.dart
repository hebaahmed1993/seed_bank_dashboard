import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/pagination_action.dart';
import '../../../../../core/enums/status_filter.dart';
import '../../../../../core/localization/l10n/app_localizations.dart'; // 👈 استيراد الترجمة
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_search_bar.dart';
import '../../providers/suppliers_provider.dart';

class SuppliersFilterSection extends ConsumerStatefulWidget {
  const SuppliersFilterSection({super.key});

  @override
  ConsumerState<SuppliersFilterSection> createState() => _SuppliersFilterSectionState();
}

class _SuppliersFilterSectionState extends ConsumerState<SuppliersFilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    ref.read(supplierSearchQueryProvider.notifier).state = query.trim();

    ref.read(suppliersNotifierProvider.notifier).fetchPage(
      action: PaginationAction.refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // 👈 تعريف l10n
    final selectedFilter = ref.watch(supplierStatusFilterProvider);

    return Row(
      children: [
        Expanded(
          child: CustomFilterBar(
            searchController: _searchController,
            searchHint: 'بحث باسم الشركة / المورد (اضغط Enter)...',
            onSubmitted: (value) => _executeSearch(value),
            onSearchChanged: (value) {
              if (value.isEmpty && ref.read(supplierSearchQueryProvider).isNotEmpty) {
                _executeSearch('');
              }
            },
          ),
        ),

        SizedBox(width: 12.w),

        // 2. 🎯 فلتر الحالة
        SizedBox(
          width: 160.w,
          child: CustomDropdownFormField<StatusFilter>(
            value: selectedFilter,
            labelText: 'الحالة',
            prefixIcon: Icons.filter_list_rounded,
            items: StatusFilter.values.map((filter) {
              return DropdownMenuItem<StatusFilter>(
                value: filter,
                child: Text(filter.label(l10n)),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null && newValue != selectedFilter) {
                ref.read(supplierStatusFilterProvider.notifier).state = newValue;
                ref.read(suppliersNotifierProvider.notifier).fetchPage(
                  action: PaginationAction.refresh,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}