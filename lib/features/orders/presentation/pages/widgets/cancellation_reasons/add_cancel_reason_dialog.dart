import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../data/models/cancel_reason_model.dart';
import '../../../providers/orders_provider.dart';

class AddCancelReasonDialog extends ConsumerStatefulWidget {
  const AddCancelReasonDialog({super.key});

  @override
  ConsumerState<AddCancelReasonDialog> createState() => _AddCancelReasonDialogState();
}

class _AddCancelReasonDialogState extends ConsumerState<AddCancelReasonDialog> {
  final _reasonArController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(ordersNotifierProvider);

    final isLoading = state.addCancelReasonStatus == RequestStatus.loading;

    // 🎯 الاستماع لحالة الإضافة
    ref.listen(ordersNotifierProvider, (previous, next) {
      if (previous?.addCancelReasonStatus != next.addCancelReasonStatus) {
        if (next.addCancelReasonStatus == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.newCancelReasonRegisteredSuccess,
          );
        } else if (next.addCancelReasonStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.unexpectedError,
          );
        }
      }
    });

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Icon(Icons.add_alert, color: colorScheme.primary, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            l10n.addNewCancelReasonSystem,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
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
                l10n.newReasonDisclaimer,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 16.h),

              CustomTextFormField(
                controller: _reasonArController,
                labelText: l10n.cancelReasonArLabel,
                enabled: !isLoading,
                validator: requiredValidator,
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
          width: 150.w,
          height: 45.h,
          child: ButtonApp(
            onPressed: isLoading
                ? null
                : () {
              if (_formKey.currentState!.validate()) {
                final generatedId = 'reason_${DateTime.now().millisecondsSinceEpoch}';
                final newReason = CancelReasonModel(
                  reasonId: generatedId,
                  reasonAr: _reasonArController.text.trim(),
                  isActive: true, // 💡 الأفضل أن تكون مفعلة تلقائياً عند الإضافة
                );
                ref.read(ordersNotifierProvider.notifier).addCancelReason(newReason);
              }
            },
            text: l10n.saveAndRegister,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}