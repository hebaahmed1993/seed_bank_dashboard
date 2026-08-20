enum AppThemeMode {
  light,
  dark,
  system;

  // في Dart الحديثة لا تحتاج لكتابة String get name لأنها موجودة تلقائياً في الـ Enum،
  // ولكن إن أردت تعريفها يدوياً يجب شمل جميع الحالات:
  String get value {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  static AppThemeMode fromString(String? value) {
    switch (value) {
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      case 'light':
      default:
        return AppThemeMode.light;
    }
  }
}