import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_initializer.dart';
import 'app/seed_bank_dashboard_app.dart';
import 'core/storage/shared_preferences_service.dart';
import 'di/app_services_provider.dart';

void main() async {
  final SharedPreferences prefs = await AppInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(prefs),
        ),
      ],
      child: const SeedBankDashboardApp(),
    ),
  );
}