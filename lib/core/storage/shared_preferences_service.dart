import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_configs.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // --- 1. إدارة اللغة ---
  String getLanguage() {
    return _prefs.getString(AppConfigs.keyLanguage) ?? AppConfigs.defaultLanguage;
  }

  Future<bool> setLanguage(String langCode) async {
    return await _prefs.setString(AppConfigs.keyLanguage, langCode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConfigs.keyThemeMode) ?? AppConfigs.defaultThemeMode;
  }

  Future<bool> setThemeMode(String themeMode) async {
    return await _prefs.setString(AppConfigs.keyThemeMode, themeMode);
  }

  // --- 3. إدارة لون الهوية الديناميكي ---
  Color getPrimaryColor() {
    final colorVal = _prefs.getInt(AppConfigs.keyPrimaryColor);
    if (colorVal != null) {
      return Color(colorVal);
    }
    // في حال عدم وجود AppConfigs.defaultPrimaryColor يمكنك استخدام AppColors.primary
    return AppConfigs.defaultPrimaryColor;
  }

  // استخدمنا نفس الاسم الذي استدعيناه في واجهة GeneralSettingsTab
  Future<bool> savePrimaryColor(Color color) async {
    // تم استخدام AppConfigs.keyPrimaryColor لتوحيد المفاتيح
    return await _prefs.setInt(AppConfigs.keyPrimaryColor, color.toARGB32());
  }
}