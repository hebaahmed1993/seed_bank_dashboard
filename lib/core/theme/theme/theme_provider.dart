import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../di/app_services_provider.dart';
import '../../../core/enums/app_theme_mode.dart';
import '../../../features/settings/data/models/dashboard_settings_model.dart';
import 'app_constants.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, DashboardSettingsModel>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<DashboardSettingsModel> {
  final Ref _ref;

  ThemeModeNotifier(this._ref) : super(DashboardSettingsModel.defaults()) {
    _loadAllSettings(); // 🎯 التحميل الشامل عند الإقلاع باستخدام المودل
  }

  void _loadAllSettings() {
    final prefs = _ref.read(sharedPreferencesServiceProvider);

    final savedThemeStr = prefs.getThemeMode();
    final themeMode = AppThemeMode.fromString(savedThemeStr);

    final savedPrimary = prefs.getPrimaryColor();

    // 🎯 التحديث هنا: البحث في القائمة الجديدة brandColorPalettes
    final matchedPalette = StaticData.brandColorPalettes.firstWhere(
          (palette) => palette.primary.value == savedPrimary.value,
      orElse: () => StaticData.brandColorPalettes.first, // الافتراضي في حال عدم التطابق
    );

    final savedLang = prefs.getLanguage();
    final locale = Locale(savedLang);

    state = DashboardSettingsModel(
      primaryColor: matchedPalette.primary,
      backgroundColor: matchedPalette.background,
      surfaceColor:      matchedPalette.infoContainer,
      textColor: matchedPalette.textPrimary,
      languageCode: locale,
      themeMode: themeMode,
      dashboardName:  'لوحة تحكم غِراس السحابية',
    );
  }

  // 🎯 تحديث دالة تغيير اللون لتستقبل surface وتخزنه في الحالة
  Future<void> setPrimaryColor(
      Color color,
      Color background,
      Color surface,
      Color text,
      ) async {
    final prefs = _ref.read(sharedPreferencesServiceProvider);
    await prefs.savePrimaryColor(color);

    state = state.copyWith(
      primaryColor: color,
      backgroundColor: background,
      surfaceColor: surface, // 🎯 تحديث الحالة
      textColor: text,
    );
  }

  // تغيير وحفظ المظهر (استخدام الـ Enum مباشرة)
  Future<void> setTheme(AppThemeMode themeMode) async {
    final prefs = _ref.read(sharedPreferencesServiceProvider);
    await prefs.setThemeMode(themeMode.name);

    // استخدام copyWith المتوفر في المودل بسلاسة
    state = state.copyWith(themeMode: themeMode);
  }

  // تغيير وحفظ اللغة المركزية
  Future<void> setLanguage(String langCode) async {
    final prefs = _ref.read(sharedPreferencesServiceProvider);
    await prefs.setLanguage(langCode);

    state = state.copyWith(languageCode: Locale(langCode));
  }
}