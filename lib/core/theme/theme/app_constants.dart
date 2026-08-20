


import 'package:flutter/material.dart';

import '../../localization/l10n/app_localizations.dart';
import 'app_colors.dart';



class BrandColorPalette {
  // الألوان الرئيسية
  final Color primary;
  final Color secondary;
  final Color background;

  // ألوان الحالات والنصوص
  final Color warningContainer;
  final Color successContainer;
  final Color infoContainer;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  const BrandColorPalette({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.warningContainer,
    required this.successContainer,
    required this.infoContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
  });
}




class CurrencyInfo {
  final String code;    // مثلاً: LYD, USD
  final String symbol;  // مثلاً: د.ل, $
  final String nameAr;  // مثلاً: دينار ليبي, دولار أمريكي

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.nameAr,
  });
}


class AppLanguageItem {
  final String code;
  final String name;

  const AppLanguageItem({required this.code, required this.name});
}
class StaticData {


  static final List<AppLanguageItem> supportedLanguages = [
    AppLanguageItem(code: 'ar', name: 'العربية (Arabic)'),
    AppLanguageItem(code: 'en', name: 'الإنجليزية (English)'),
  ];



  static final List<BrandColorPalette> brandColorPalettes = [
    // 1. الثيم الافتراضي (Light Theme المرفق)
    const BrandColorPalette(
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandSecondary,
      background: AppColors.brandLightBlue,        // 🎯 اللون الأزرق/الرمادي الفاتح لخلفية الشاشة
      warningContainer: AppColors.brandPeach,
      successContainer: AppColors.brandMint,
      infoContainer: AppColors.brandBackgroundLight, // 🎯 استخدمناه كلون للأسطح (Surface) والكروت
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      error: AppColors.error,
    ),

    // تم إيقاف باقي الثيمات مؤقتاً لحين تجهيز ألوانها الـ 9 الخاصة بها
  ];


  static const List<Color> brandColors = [
    Color(0xFF274C5B), // الأزرق الأردوازي الداكن (لون الهوية الرئيسي الجديد للوحة التحكم)
    Color(0xFF1E5631), // أخضر غِراس الافتراضي
    Color(0xFF8D6E63), // البني الترابي للبذور والأسمدة
    Color(0xFFFFB300), // الأصفر الكهرماني للمعدات الزراعية
    Color(0xFF0288D1), // الأزرق النقي لأنظمة الري والمياه
  ];
  // static List<Map<String, dynamic>> getStatuses(AppLocalizations l10n) => [
  // {'value': 'all', 'label': 'جميع الحالات', 'color': AppColors.success},
  // {'value': 'active', 'label': l10n.activeStatus, 'color': AppColors.success},
  // {'value': 'blocked', 'label': l10n.blockedStatus, 'color': AppColors.error},
  // ];
  //

  static const List<CurrencyInfo> supportedCurrencies = [
    CurrencyInfo(code: 'LYD', symbol: 'د.ل', nameAr: 'دينار ليبي'),
    CurrencyInfo(code: 'USD', symbol: '\$', nameAr: 'دولار أمريكي'),
    CurrencyInfo(code: 'SAR', symbol: 'ر.س', nameAr: 'ريال سعودي'),
    CurrencyInfo(code: 'EGP', symbol: 'ج.م', nameAr: 'جنيه مصري'),
    CurrencyInfo(code: 'AED', symbol: 'د.إ', nameAr: 'درهم إماراتي'),
    CurrencyInfo(code: 'EUR', symbol: '€', nameAr: 'يورو'),
  ];
  static const List<Map<String, String>> libyanCities = [
    {'id': 'Tripoli', 'name': 'طرابلس'},
    {'id': 'Benghazi', 'name': 'بنغازي'},
    {'id': 'Misrata', 'name': 'مصراتة'},
    {'id': 'Sebha', 'name': 'سبها'},
    {'id': 'Zawiya', 'name': 'الزاوية'},
    {'id': 'Khoms', 'name': 'الخمس'},
  ];

// 1. تحديث قائمة التبويبات في كود الإعدادات الثابتة
  static const List<Map<String, dynamic>> settingsTabs = [
    {"title": "إدارة المدن", "icon": Icons.location_city_outlined},
    {"title": "إدارة المناطق والتوصيل", "icon": Icons.map_outlined},
    {"title": "التنبيهات والمخزون", "icon": Icons.notifications_active_outlined},
    {"title": "أسباب الإلغاء", "icon": Icons.cancel_presentation_outlined},
    {"title": "حالات الطلبيات", "icon": Icons.fact_check_outlined},
    {"title": "المشرفين والصلاحيات", "icon": Icons.people_alt_outlined},
    {"title": "الإعدادات العامة", "icon": Icons.tune_outlined},
    {"title": "إعدادات لوحة التحكم", "icon": Icons.display_settings},
  ];
  static const List<String> deliveryDurationOptions = [
    'نفس اليوم',
    'خلال 24 ساعة',
    'يوم - يومين',
    'يومين - 3 أيام',
    '3 - 5 أيام',
    'أسبوع'
  ];
  static final List<String> presetColors = [
    '#2196F3',
    '#FF9800',
    '#4CAF50',
    '#F44336',
    '#9C27B0',
    '#009688',
    '#FFC107',
    '#757575',
  ];







}


class FirestorePaths {
  FirestorePaths._(); // يمنع إنشاء نسخة من الكلاس

  // الجداول الأساسية
  static const String users = 'users';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String suppliers = 'suppliers';
  static const String categories = 'categories';

  // الإعدادات والثوابت
  static const String appSettings = 'appSettings';
  static const String accountTypes = 'accountTypes';
  static const String cancelReasons = 'cancelReasons';
  static const String cities = 'cities';
  static const String regions = 'regions';
  static const String deliveryFees = 'deliveryFees';
  static const String orderStatuses = 'orderStatuses';
  static const String paymentMethods = 'paymentMethods';
  static const String permissions = 'permissions';

  // السجلات والحركات
  static const String activityLogs = 'activity_logs';
  static const String inventoryMovements = 'inventoryMovements';
}