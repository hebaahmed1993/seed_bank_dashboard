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

class EditRegionDialog extends ConsumerStatefulWidget {
  final RegionModel region;
  const EditRegionDialog({super.key, required this.region});

  @override
  ConsumerState<EditRegionDialog> createState() => _EditRegionDialogState();
}

class _EditRegionDialogState extends ConsumerState<EditRegionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _feeController;

  late List<String> _currentOptions;
  String? _selectedDuration;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.region.name);
    _feeController = TextEditingController(text: widget.region.baseFee.toString());

    _currentOptions = List.from(StaticData.deliveryDurationOptions);
    if (widget.region.estimatedDays.isNotEmpty && !_currentOptions.contains(widget.region.estimatedDays)) {
      _currentOptions.add(widget.region.estimatedDays);
    }
    _selectedDuration = widget.region.estimatedDays.isNotEmpty ? widget.region.estimatedDays : null;
  }

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
    final regionsState = ref.watch(locationsNotifierProvider);

    // 🎯 الاستماع لحالة التعديل
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.updateRegionStatus != previous?.updateRegionStatus) {
        if (next.updateRegionStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: "تم تحديث بيانات المنطقة بنجاح", // أو استخدم l10n
          );
        }
      }
    });

    final isLoading = regionsState.updateRegionStatus == RequestStatus.loading;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(l10n.editRegionTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: colorScheme.onSurface)),
      content: SizedBox(
        width: 450.w,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: _nameArController,
                labelText: l10n.regionNameArLabel,
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
                      items: _currentOptions.map((duration) {
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
              if (_formKey.currentState!.validate() && _selectedDuration != null) {
                ref.read(locationsNotifierProvider.notifier).updateRegionDetails(
                  regionId: widget.region.regionId,
                  name: _nameArController.text.trim(),
                  baseFee: double.parse(_feeController.text.trim()),
                  estimatedDays: _selectedDuration!,
                );
              }
            },
            text: isLoading ? l10n.editProgress : l10n.editDetails,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}