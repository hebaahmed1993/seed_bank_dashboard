import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/custom_search_bar.dart';
import 'region_header_widget.dart';
import 'region_table_section.dart';

class RegionsDeliveryTab extends StatefulWidget {
  const RegionsDeliveryTab({super.key});

  @override
  State<RegionsDeliveryTab> createState() => _RegionsDeliveryTabState();
}

class _RegionsDeliveryTabState extends State<RegionsDeliveryTab> {
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
        const RegionHeaderWidget(),
        SizedBox(height: 24.h),

        // 2. شريط البحث
        SizedBox(
          width: 350.w,
          child: CustomSearchBar(
            controller: _searchController,
            hintText: l10n.searchRegionHint,
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
          child: RegionTableSection(searchQuery: _searchQuery),
        ),
      ],
    );
  }
}