import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seed_bank_dashboard/features/products/presentation/pages/widgets/products_header_widget.dart';

import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/button_app.dart';
import 'product_form_dialog.dart';
import 'products_filter_section.dart';
import 'products_table_section.dart';

class ProductsListView extends ConsumerWidget {
  const ProductsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductsHeaderWidget(),
          SizedBox(height: 32.h),

          // 2. شريط الفلاتر والبحث
          const ProductsFilterSection(),
          SizedBox(height: 24.h),

          // 3. جدول البيانات
          const Expanded(
            child: ProductsTableSection(),
          ),
        ],
      ),
    );
  }
}
