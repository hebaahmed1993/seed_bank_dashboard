import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/custom_table.dart';
import '../../../../../../core/widgets/custom_switch.dart';
import '../../../../../../core/widgets/custom_edit_button.dart';
import '../../../providers/locations_provider.dart';
import 'edit_region_dialog.dart';

class RegionTableSection extends ConsumerWidget {
  final String searchQuery;

  const RegionTableSection({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final regionsAsyncValue = ref.watch(regionsStreamProvider);
    final locationsState = ref.watch(locationsNotifierProvider);

    // 🎯 الاستماع لحالة التحديث (تغيير الحالة أو التعديل)
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.updateRegionStatus != previous?.updateRegionStatus) {
        if (next.updateRegionStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.statusUpdateFailed(""),
          );
        }
      }
    });

    return regionsAsyncValue.when(
      data: (regionsList) {
        final filteredRegions = regionsList.where((region) {
          final nameAr = region.name.toLowerCase();
          return nameAr.contains(searchQuery);
        }).toList();

        final columns = [
          DataColumn(label: Text(l10n.serialNumberColumn)),
          DataColumn(label: Text(l10n.regionColumn)),
          DataColumn(label: Text(l10n.cityColumn)),
          DataColumn(label: Text(l10n.deliveryFeeColumn)),
          DataColumn(label: Text(l10n.deliveryTimeColumn)),
          DataColumn(label: Text(l10n.deliveryStatusColumn)),
          DataColumn(label: Text(l10n.actionsColumn)),
        ];

        final rows = List<DataRow>.generate(
          filteredRegions.length,
              (index) {
            final region = filteredRegions[index];
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  Text(
                    region.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(
                  Text(
                    region.cityName ?? region.cityId,
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                  ),
                ),
                DataCell(
                  Text(
                    '${region.baseFee} ${l10n.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    region.estimatedDays,
                    style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface),
                  ),
                ),
                DataCell(
                  CustomSwitch(
                    value: region.isAvailable,
                    onChanged: (newValue) {
                      ref.read(locationsNotifierProvider.notifier).toggleRegionStatus(
                        regionId: region.regionId,
                        isAvailable: newValue,
                      );
                    },
                  ),
                ),
                DataCell(
                  CustomEditButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => EditRegionDialog(region: region),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );

        return CustomTable(
          columns: columns,
          rows: rows,
          isLoading: locationsState.updateRegionStatus == RequestStatus.loading,
          emptyMessage: searchQuery.isEmpty
              ? l10n.noRegisteredRegions
              : l10n.noMatchingRegions,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.errorLoadingRegions(error.toString()),
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
