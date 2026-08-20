import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/selection_mode.dart';
import '../../../data/models/home_section_model.dart';

class FilterCell extends StatelessWidget {
  final HomeSectionModel section;
  const FilterCell({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.selectionMode == SelectionMode.manual) {
      return Text(
        '${section.productIds.length} منتج مختار',
        style: TextStyle(fontSize: 13.sp),
      );
    }

    return Text(
      section.dynamicFilterType?.label ?? '—',
      style: TextStyle(fontSize: 13.sp),
    );
  }
}