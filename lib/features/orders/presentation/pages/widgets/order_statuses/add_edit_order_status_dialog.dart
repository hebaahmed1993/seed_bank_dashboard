import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/request_status.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/utils/custom_snackbar.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../data/models/order_status_model.dart';
import '../../../providers/orders_provider.dart';

class AddEditOrderStatusDialog extends ConsumerStatefulWidget {
  final OrderStatusModel? statusToEdit;
  const AddEditOrderStatusDialog({super.key, this.statusToEdit});

  @override
  ConsumerState<AddEditOrderStatusDialog> createState() => _AddEditOrderStatusDialogState();
}

class _AddEditOrderStatusDialogState extends ConsumerState<AddEditOrderStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _colorController;

  bool get isEditing => widget.statusToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.statusToEdit?.name ?? '');
    _descController = TextEditingController(text: widget.statusToEdit?.description ?? '');
    _colorController = TextEditingController(text: widget.statusToEdit?.colorHex ?? '#000000');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(ordersNotifierProvider);

    // 🎯 التصحيح 1: استخدام updateOrderStatusDetailsStatus بدلاً من updateOrderStatusStatus
    final isLoading = isEditing
        ? state.updateOrderStatusDetailsStatus == RequestStatus.loading
        : state.addOrderStatusStatus == RequestStatus.loading;

    // 🎯 التصحيح 2: الاستماع للحالة الصحيحة في نافذة التعديل
    ref.listen(ordersNotifierProvider, (previous, next) {
      final statusToCheck = isEditing ? next.updateOrderStatusDetailsStatus : next.addOrderStatusStatus;
      final prevStatusToCheck = isEditing ? previous?.updateOrderStatusDetailsStatus : previous?.addOrderStatusStatus;

      if (statusToCheck != prevStatusToCheck) {
        if (statusToCheck == RequestStatus.success) {
          Navigator.pop(context);
          CustomSnackBar.showSuccess(
            context: context,
            message: isEditing ? "تم التعديل بنجاح" : "تمت الإضافة بنجاح",
          );
        } else if (statusToCheck == RequestStatus.error) {
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
          Icon(isEditing ? Icons.edit : Icons.add_task, color: colorScheme.primary, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            isEditing ? l10n.editDetails : l10n.addNewStatus,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 450.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: _nameController,
                labelText: l10n.statusNameColumn,
                enabled: !isLoading,
                validator: requiredValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _descController,
                labelText: l10n.statusDescriptionColumn,
                enabled: !isLoading,
                validator: requiredValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _colorController,
                labelText: l10n.statusColorColumn,
                hintText: "#FFFFFF",
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
                final newStatus = OrderStatusModel(
                  statusId: isEditing ? widget.statusToEdit!.statusId : 'status_${DateTime.now().millisecondsSinceEpoch}',
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  colorHex: _colorController.text.trim(),
                  isActive: isEditing ? widget.statusToEdit!.isActive : true,
                );

                if (isEditing) {
                  ref.read(ordersNotifierProvider.notifier).updateOrderStatusDetails(newStatus);
                } else {
                  ref.read(ordersNotifierProvider.notifier).addOrderStatus(newStatus);
                }
              }
            },
            text: isLoading ? l10n.savingProgress : l10n.saveAndRegister,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}