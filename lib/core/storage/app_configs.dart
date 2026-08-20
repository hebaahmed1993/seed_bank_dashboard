import 'package:flutter/material.dart';

class AppConfigs {
  // --- 1. إعدادات Firebase ---
  static const String firebaseApiKey = "AIzaSyA7-52fnh9592961fLrox9KlDxV0KmZ2Cg";
  static const String firebaseAuthDomain = "seed-bank-ly.firebaseapp.com";
  static const String firebaseProjectId = "seed-bank-ly";
  static const String firebaseStorageBucket = "seed-bank-ly.firebasestorage.app";
  static const String firebaseMessagingSenderId = "898791648221";
  static const String firebaseAppId = "1:898791648221:web:d393db2cec859d22e92434";

  // --- 2. المفاتيح الخاصة بالتخزين المحلي (Storage Keys) ---
  static const String keyLanguage = 'selected_language';
  static const String keyThemeMode = 'selected_theme_mode';
  static const String keyPrimaryColor = 'selected_primary_color';

  // --- 3. القيم الافتراضية للنظام (Default Fallbacks) ---
  static const String defaultLanguage = 'ar';
  static const String defaultThemeMode = 'light'; // الوضع الفاتح
  static const Color defaultPrimaryColor = Color(0xFF1E5631); // أخضر غِراس الافتراضي
}