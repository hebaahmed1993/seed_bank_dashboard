import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================================
  // 1. ألوان الهوية البصرية من التصميم (Brand Colors)
  // =========================================
  static const Color brandPrimary = Color(0xFF265166);       // الأزرق الداكن الأساسي
  static const Color brandSecondary = Color(0xFF547C90);     // الأزرق الفاتح الثانوي
  static const Color brandBackgroundLight = Color(0xFFF6FAFD); // خلفية الوضع الفاتح

  // ألوان الوضع الداكن من التصميم
  static const Color brandBackgroundDark = Color(0xFF121212); // خلفية الوضع الداكن
  static const Color brandSurfaceDark1 = Color(0xFF193A4A);   // أسطح الوضع الداكن 1
  static const Color brandSurfaceDark2 = Color(0xFF2D6079);   // أسطح الوضع الداكن 2

  // ألوان إضافية من لوحة التصميم المرفقة
  static const Color brandPeach = Color(0xFFF1DCD0);
  static const Color brandMint = Color(0xFFD0F1E6);
  static const Color brandLightBlue = Color(0xFFBACFDA);
  static const Color brandDarkBlue = Color(0xFF1E3745);
  static const Color brandGrey = Color(0xFF414A4E);

  // =========================================
  // 2. الألوان الدلالية (Semantic Colors)
  // =========================================
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFD84315);
  static const Color error = Color(0xFFCA4C44); // 🎯 تم استخدام الأحمر من التصميم
  static const Color info = Color(0xFF547C90);

  // =========================================
  // 3. ألوان النصوص (Typography)
  // =========================================
  static const Color textPrimaryLight = Color(0xFF1E3745);
  static const Color textSecondaryLight = Color(0xFF414A4E);
  static const Color textPrimaryDark = Color(0xFFF6FAFD);
  static const Color textMuted = Color(0xFF95999C);
}