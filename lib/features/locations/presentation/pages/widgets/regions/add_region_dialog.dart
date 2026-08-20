import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/theme/app_constants.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../../data/models/region_model.dart';
import '../../../providers/locations_provider.dart';

class AddRegionDialog extends ConsumerStatefulWidget {
  const AddRegionDialog({super.key});

  @override
  ConsumerState<AddRegionDialog> createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends ConsumerState<AddRegionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _feeController = TextEditingController();

  String? _selectedCityId;
  String? _selectedDuration;

  @override
  void dispose() {
    _nameArController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final citiesAsync = ref.watch(citiesStreamProvider);
    final regionsState = ref.watch(locationsNotifierProvider);

    // 🎯 الاستماع لحالة الإضافة
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.addRegionStatus != previous?.addRegionStatus) {
        if (next.addRegionStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: "تم إضافة المنطقة بنجاح", // أو استخدم l10n
          );
        } else if (next.addRegionStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: l10n.addFailedError(next.errorMessage ?? ''),
          );
        }
      }
    });

    final isLoading = regionsState.addRegionStatus == RequestStatus.loading;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        l10n.addNewDeliveryRegionTitle,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: colorScheme.onSurface),
      ),
      content: SizedBox(
        width: 500.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                citiesAsync.when(
                  data: (citiesList) {
                    final activeCities = citiesList.where((c) => c.isActive).toList();
                    return CustomDropdownFormField<String>(
                      value: _selectedCityId,
                      labelText: l10n.parentCityLabel,
                      items: activeCities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city.cityId,
                          child: Text(city.name, style: TextStyle(fontSize: 14.sp)),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                        setState(() {
                          _selectedCityId = value;
                        });
                      },
                      validator: (val) => val == null ? l10n.selectParentCityValidator : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => Text(l10n.errorFetchingCities, style: TextStyle(fontSize: 14.sp, color: colorScheme.error)),
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _nameArController,
                  labelText: l10n.regionNameLabel,
                  prefixIcon: Icons.map_outlined,
                  validator: requiredValidator,
                  enabled: !isLoading,
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _feeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        labelText: l10n.deliveryFeeInputLabel,
                        prefixIcon: Icons.attach_money,
                        validator: priceValidator,
                        enabled: !isLoading,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomDropdownFormField<String>(
                        value: _selectedDuration,
                        labelText: l10n.deliveryDurationLabel,
                        items: StaticData.deliveryDurationOptions.map((duration) {
                          return DropdownMenuItem(
                            value: duration,
                            child: Text(duration, style: TextStyle(fontSize: 14.sp)),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                          setState(() {
                            _selectedDuration = value;
                          });
                        },
                        validator: requiredValidator,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14.sp)),
        ),
        SizedBox(
          width: 140.w,
          height: 45.h,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () {
              if (_formKey.currentState!.validate() && _selectedCityId != null && _selectedDuration != null) {
                final newRegion = RegionModel(
                  regionId: '', // سيتم توليده في الـ DataSource
                  cityId: _selectedCityId!,
                  name: _nameArController.text.trim(),
                  baseFee: double.parse(_feeController.text.trim()),
                  estimatedDays: _selectedDuration!,
                  isAvailable: true,
                );
                ref.read(locationsNotifierProvider.notifier).addRegion(newRegion);
              }
            },
            text: isLoading ? l10n.savingProgress : l10n.add,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}