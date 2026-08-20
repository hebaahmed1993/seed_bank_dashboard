

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../providers/orders_provider.dart';

class OrderStatusDropdown extends ConsumerWidget {
  final String? selectedValue;
  final void Function(String?) onChanged;

  const OrderStatusDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  Color _parseHexColor(String hexString) {
    try {
      final cleanHex = hexString.replaceAll('#', '').trim();
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statusesAsync = ref.watch(orderStatusesStreamProvider);

    return statusesAsync.when(
      data: (statuses) {
        return CustomDropdownFormField<String>(
          value: selectedValue,
          labelText: l10n.statusColumn,
          prefixIcon: Icons.filter_list_rounded,
          items: [
            const DropdownMenuItem(
              value: 'all',
              child: Text('جميع الحالات', style: TextStyle(color: AppColors.success)),
            ),
            ...statuses.map((status) {
              return DropdownMenuItem(
                value: status.statusId,
                child: Text(
                  status.nameAr,
                  style: TextStyle(color: _parseHexColor(status.colorHex)),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}