// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
//
// import '../../../di/app_services_provider.dart';
//
// final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
//   return LocaleNotifier(ref);
// });
//
// class LocaleNotifier extends StateNotifier<Locale> {
//   final Ref _ref;
//
//   LocaleNotifier(this._ref) : super(const Locale('ar')) {
//     _loadSavedLocale();
//   }
//
//   // قراءة اللغة المخزنة عند إقلاع التطبيق
//   void _loadSavedLocale() {
//     final prefs = _ref.read(sharedPreferencesServiceProvider);
//     state = Locale(prefs.getLanguage());
//   }
//
//   // تغيير اللغة وحفظها مباشرة في التخزين المحلي
//   Future<void> setLocale(String langCode) async {
//     final prefs = _ref.read(sharedPreferencesServiceProvider);
//     await prefs.setLanguage(langCode);
//     state = Locale(langCode);
//   }
// }