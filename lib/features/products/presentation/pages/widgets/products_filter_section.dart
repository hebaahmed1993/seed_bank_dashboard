import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/pagination_action.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../../core/widgets/custom_search_bar.dart';
import '../../../../categories/presentation/providers/categories_provider.dart';
import '../../providers/products_provider.dart';

class ProductsFilterSection extends ConsumerStatefulWidget {
  const ProductsFilterSection({super.key});

  @override
  ConsumerState<ProductsFilterSection> createState() => _ProductsFilterSectionState();
}

class _ProductsFilterSectionState extends ConsumerState<ProductsFilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    ref.read(productSearchQueryProvider.notifier).state = query.trim();
    ref.read(productsNotifierProvider.notifier).fetchPage(
          action: PaginationAction.refresh,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedCategory = ref.watch(productCategoryFilterProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    return Row(
      children: [
        // 1. شريط البحث
        Expanded(
          child: CustomFilterBar(
            searchController: _searchController,
            searchHint: 'البحث باسم المنتج (اضغط Enter)...',
            onSubmitted: (value) => _executeSearch(value),
            onSearchChanged: (value) {
              if (value.isEmpty && ref.read(productSearchQueryProvider).isNotEmpty) {
                _executeSearch('');
              }
            },
          ),
        ),

        SizedBox(width: 16.w),

        Expanded(
          child: categoriesAsync.when(
            data: (categoryList) {
              return CustomDropdownFormField<String?>(
                value: selectedCategory,
                labelText: l10n.mainCategoryLabel,
                prefixIcon: Icons.category_outlined,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('كل التصنيفات'),
                  ),
                  ...categoryList.map((cat) {
                    return DropdownMenuItem<String?>(
                      value: cat.id,
                      child: Text(
                         cat.name,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  ref.read(productCategoryFilterProvider.notifier).state = value;
                  ref.read(productsNotifierProvider.notifier).fetchPage(
                        action: PaginationAction.refresh,
                      );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
