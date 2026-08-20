import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/app_theme_mode.dart';
import '../../../../core/theme/theme/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../../../../di/app_services_provider.dart';

// ==========================================
// 1. DashboardSettingsModel
// ==========================================
class DashboardSettingsModel {
  final Color primaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Locale languageCode;
  final AppThemeMode themeMode;
  final String dashboardName;

  const DashboardSettingsModel({
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.languageCode,
    required this.themeMode,
    required this.dashboardName,
  });

  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  factory DashboardSettingsModel.defaults() {
    // 🎯 استخدام القائمة الجديدة brandColorPalettes
    final defaultPalette = StaticData.brandColorPalettes.first;
    return DashboardSettingsModel(
      primaryColor: defaultPalette.primary,
      backgroundColor: defaultPalette.background,
      surfaceColor: Colors.white, // السطح الفاتح الافتراضي
      textColor: defaultPalette.textPrimary, // 🎯 المسمى الجديد من لوحة الألوان
      languageCode: AppLocalizations.supportedLocales.first,
      themeMode: AppThemeMode.light,
      dashboardName: 'لوحة تحكم غِراس السحابية',
    );
  }

  DashboardSettingsModel copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Locale? languageCode,
    AppThemeMode? themeMode,
    String? dashboardName,
  }) {
    return DashboardSettingsModel(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      dashboardName: dashboardName ?? this.dashboardName,
    );
  }
}

// ==========================================
// 2. ThemeModeNotifier (إن كان في نفس الملف)
// ==========================================
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, DashboardSettingsModel>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<DashboardSettingsModel> {
  final Ref _ref;

  ThemeModeNotifier(this._ref) : super(DashboardSettingsModel.defaults()) {
    _loadAllSettings();
  }

  void _loadAllSettings() {
    final prefs = _ref.read(sharedPreferencesServiceProvider);

    final savedThemeStr = prefs.getThemeMode();
    final themeMode = AppThemeMode.fromString(savedThemeStr);
    final savedPrimary = prefs.getPrimaryColor();

    // 🎯 التحديث هنا: البحث في brandColorPalettes
    final matchedPalette = StaticData.brandColorPalettes.firstWhere(
          (palette) => palette.primary.value == savedPrimary.value,
      orElse: () => StaticData.brandColorPalettes.first,
    );

    final savedLang = prefs.getLanguage();
    final locale = Locale(savedLang);

    state = DashboardSettingsModel(
      primaryColor: matchedPalette.primary,
      backgroundColor: matchedPalette.background,
      surfaceColor: matchedPalette.infoContainer,
      textColor: matchedPalette.textPrimary,
      languageCode: locale,
      themeMode: themeMode,
      dashboardName: 'لوحة تحكم غِراس السحابية',
    );
  }

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
      surfaceColor: surface,
      textColor: text,
    );
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    final prefs = _ref.read(sharedPreferencesServiceProvider);
    await prefs.setThemeMode(themeMode.name);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> setLanguage(String langCode) async {
    final prefs = _ref.read(sharedPreferencesServiceProvider);
    await prefs.setLanguage(langCode);
    state = state.copyWith(languageCode: Locale(langCode));
  }
}