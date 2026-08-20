import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/localization/l10n/app_localizations.dart';
import '../core/theme/theme/theme_provider.dart';
import '../core/theme/theme/app_theme.dart';
import '../features/settings/data/models/dashboard_settings_model.dart' show DashboardSettingsModel;
import 'app_routes.dart';



class SeedBankDashboardApp extends ConsumerWidget {
  const SeedBankDashboardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final  DashboardSettingsModel settings = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: settings.dashboardName,
          debugShowCheckedModeBanner: false,

          locale: settings.languageCode,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: AppRoutes.initial,
          onGenerateRoute: AppRoutes.onGenerateRoute,

          // ربط المظهر عبر الـ Getter الموجود في المودل
          themeMode: settings.flutterThemeMode,

          // تمرير المودل لكلاس AppTheme ليقوم بالبناء الديناميكي مع خطوط GoogleFonts
          theme: AppTheme.lightTheme(settings),
          darkTheme: AppTheme.darkTheme(settings),
        );
      },
    );
  }
}