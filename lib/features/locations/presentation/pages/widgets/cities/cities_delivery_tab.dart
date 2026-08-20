import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/custom_search_bar.dart';
import 'city_header_widget.dart';
import 'city_table_section.dart';

class CitiesDeliveryTab extends StatefulWidget {
  const CitiesDeliveryTab({super.key});

  @override
  State<CitiesDeliveryTab> createState() => _CitiesDeliveryTabState();
}

class _CitiesDeliveryTabState extends State<CitiesDeliveryTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الترويسة الموحدة
        const CityHeaderWidget(),
        SizedBox(height: 24.h),

        // 2. شريط البحث
        SizedBox(
          width: 350.w,
          child: CustomSearchBar(
            controller: _searchController,
            hintText: l10n.searchCityHint,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim().toLowerCase();
              });
            },
          ),
        ),
        SizedBox(height: 24.h),

        // 3. جدول البيانات المخصص
        Expanded(
          child: CityTableSection(searchQuery: _searchQuery),
        ),
      ],
    );
  }
}