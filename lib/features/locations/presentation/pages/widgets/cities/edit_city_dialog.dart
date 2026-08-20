import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/utils/custom_snackbar.dart'; // 🎯 استدعاء CustomSnackBar
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../data/models/city_model.dart';
import '../../../providers/locations_provider.dart';

class EditCityDialog extends ConsumerStatefulWidget {
  final CityModel city;
  const EditCityDialog({super.key, required this.city});

  @override
  ConsumerState<EditCityDialog> createState() => _EditCityDialogState();
}

class _EditCityDialogState extends ConsumerState<EditCityDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.city.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationsState = ref.watch(locationsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // 🎯 إصلاح: الاستماع لحالة (updateCityStatus) وليس (addCityStatus)
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.updateCityStatus != previous?.updateCityStatus) {
        if (next.updateCityStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.cityUpdatedSuccess,
          );
        } else if (next.updateCityStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: l10n.updateFailedError(next.errorMessage ?? ''),
          );
        }
      }
    });

    // 🎯 إصلاح: مراقبة حالة التحديث بشكل صحيح
    final isLoading = locationsState.updateCityStatus == RequestStatus.loading;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        l10n.editCityTitle,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400.w,
          child: CustomTextFormField(
            controller: _nameController,
            labelText: l10n.cityNameInputLabel,
            prefixIcon: Icons.location_city,
            validator: requiredValidator,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14.sp),
          ),
        ),
        SizedBox(
          width: 140.w,
          height: 45.h,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () {
              if (_formKey.currentState!.validate()) {
                // 🎯 إرسال الطلب فقط بدون انتظار
                ref.read(locationsNotifierProvider.notifier).updateCity(
                  cityId: widget.city.cityId,
                  newName: _nameController.text.trim(),
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