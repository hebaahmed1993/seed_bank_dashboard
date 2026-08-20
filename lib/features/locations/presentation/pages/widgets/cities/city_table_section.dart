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
import 'edit_city_dialog.dart';

class CityTableSection extends ConsumerWidget {
  final String searchQuery;

  const CityTableSection({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final citiesAsyncValue = ref.watch(citiesStreamProvider);
    final locationsState = ref.watch(locationsNotifierProvider);

    // 🎯 الاستماع لحالة التحديث (Toggle) وإظهار الأخطاء إن وجدت
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.updateCityStatus != previous?.updateCityStatus) {
        if (next.updateCityStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.statusUpdateFailed(""),
          );
        }
      }
    });

    return citiesAsyncValue.when(
      data: (citiesList) {
        // 🎯 تصفية القائمة محلياً بناءً على نص البحث
        final filteredCities = citiesList.where((city) {
          final nameAr = city.name.toLowerCase();
          return nameAr.contains(searchQuery);
        }).toList();

        final columns = [
          DataColumn(label: Text(l10n.serialNumberColumn)),
          DataColumn(label: Text(l10n.cityNameColumn)),
          DataColumn(label: Text(l10n.activityStatusColumn)),
          DataColumn(label: Text(l10n.actionsColumn)),
        ];

        final rows = List<DataRow>.generate(
          filteredCities.length,
              (index) {
            final city = filteredCities[index];
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  Text(
                    city.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🎯 استخدام المكون المخصص للـ Switch
                      CustomSwitch(
                        value: city.isActive,
                        onChanged: (newValue) {
                          ref.read(locationsNotifierProvider.notifier).toggleCityStatus(
                            cityId: city.cityId,
                            isActive: newValue,
                          );
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        city.isActive ? l10n.activeStatus : l10n.inactiveStatus,
                        style: TextStyle(
                          // 🎯 الألوان متوافقة مع الثيم
                          color: city.isActive
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  // 🎯 استخدام زر التعديل الموحد
                  CustomEditButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => EditCityDialog(city: city),
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
          isLoading: locationsState.updateCityStatus == RequestStatus.loading,
          emptyMessage: searchQuery.isEmpty
              ? l10n.noRegisteredCities
              : l10n.noMatchingCities,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.errorLoadingCities(error.toString()),
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}