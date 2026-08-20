import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import '../../../features/settings/data/models/dashboard_settings_model.dart';

class AppTheme {
  AppTheme._();

  // =========================================
  // 1. المظهر الفاتح (Light Theme)
  // =========================================
  static ThemeData lightTheme(DashboardSettingsModel settings) {
    final bool isArabic = settings.languageCode.languageCode == 'ar';

    final TextTheme appTextTheme = isArabic
        ? GoogleFonts.tajawalTextTheme()
        : GoogleFonts.poppinsTextTheme(); // 💡 يمكن استبداله بـ Nunito كما في التصميم لاحقاً

    final TextStyle appBarTextStyle = isArabic
        ? GoogleFonts.tajawal(color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.bold)
        : GoogleFonts.poppins(color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.bold);

    return ThemeData(
      useMaterial3: true,
      textTheme: appTextTheme,
      primaryColor: settings.primaryColor, // يأتي من BrandColorPair (AppColors.brandPrimary)
      scaffoldBackgroundColor: settings.backgroundColor, // يأتي من BrandColorPair
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.primaryColor,
        primary: settings.primaryColor,
        surface: settings.surfaceColor, // لون الكروت (الأبيض غالباً)
        error: AppColors.error, // 🎯 ربط لون الخطأ الموحد
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: settings.backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: appBarTextStyle,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
    );
  }

  // =========================================
  // 2. المظهر الداكن (Dark Theme) - 🎯 تم ربطه بتصميمك المرفق
  // =========================================
  static ThemeData darkTheme(DashboardSettingsModel settings) {
    final bool isArabic = settings.languageCode.languageCode == 'ar';

    final TextTheme appTextTheme = isArabic
        ? GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      textTheme: appTextTheme,
      primaryColor: settings.primaryColor,
      scaffoldBackgroundColor: AppColors.brandBackgroundDark, // 🎯 #121212 من التصميم
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.primaryColor,
        primary: settings.primaryColor,
        brightness: Brightness.dark,
        surface: AppColors.brandSurfaceDark1, // 🎯 #193A4A من التصميم
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.brandBackgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
    );
  }
}