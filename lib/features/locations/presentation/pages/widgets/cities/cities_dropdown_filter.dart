import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/custom_dropdown_form_field.dart';
import '../../../providers/locations_provider.dart';

class CitiesDropdownFilter extends ConsumerWidget {
  final String? selectedValue;
  final void Function(String?) onChanged;

  const CitiesDropdownFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;


    final citiesAsync = ref.watch(citiesStreamProvider);

    return citiesAsync.when(
      data: (cities) {
        return CustomDropdownFormField<String?>(
          value: selectedValue,
          labelText: l10n.cityLabel,
          prefixIcon: Icons.location_city_outlined,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('كل المدن'),
            ),
            ...cities.map((city) {
              return DropdownMenuItem<String?>(
                value: city.cityId,
                child: Text(city.name),
              );
            }),
          ],
          onChanged: onChanged,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}