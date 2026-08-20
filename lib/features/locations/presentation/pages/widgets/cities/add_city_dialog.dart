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

class AddCityDialog extends ConsumerStatefulWidget {
  const AddCityDialog({super.key});

  @override
  ConsumerState<AddCityDialog> createState() => _AddCityDialogState();
}

class _AddCityDialogState extends ConsumerState<AddCityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationsState = ref.watch(locationsNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme; // 🎯 جلب الثيم

    // 🎯 الاستماع لحالة الإضافة للتعامل مع النجاح والفشل بدون return bool
    ref.listen(locationsNotifierProvider, (previous, next) {
      if (next.addCityStatus != previous?.addCityStatus) {
        if (next.addCityStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.cityAddedSuccess(_nameController.text.trim()),
          );
        } else if (next.addCityStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: l10n.addFailedError(next.errorMessage ?? ''),
          );
        }
      }
    });

    final isLoading = locationsState.addCityStatus == RequestStatus.loading;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        l10n.addNewCityTitle,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addCityInstruction,
                style: TextStyle(fontSize: 13.sp, color: colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                controller: _nameController,
                labelText: l10n.cityNameInputLabel,
                prefixIcon: Icons.location_city,
                validator: requiredValidator,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ),
        SizedBox(
          width: 160.w,
          height: 45.h,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () {
              if (_formKey.currentState!.validate()) {
                final newCity = CityModel(
                  cityId: '', // سيقوم الخادم أو الـ Repo بإنشاء الـ ID
                  name: _nameController.text.trim(),
                  isActive: true,
                );
                // 🎯 إرسال الطلب فقط بدون انتظار
                ref.read(locationsNotifierProvider.notifier).addNewCity(newCity);
              }
            },
            text: l10n.add,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}