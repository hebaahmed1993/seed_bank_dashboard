import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/users/presentation/pages/users_page.dart'; // استيراد الشاشة الجديدة 🎯

class AppRoutes {
  static const String initial = '/';            // شاشة البداية الافتراضية
  static const String dashboard = '/dashboard';   // لوحة التحكم المركزية
  static const String users = '/users';           // شاشة إدارة المستخدمين الجديدة

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print('🌐 [Web Routing] المتصفح يتنقل إلى: ${settings.name}');

    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashboardPage(),
        );
      case users: // إضافة حالة التوجيه لشاشة المستخدمين
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UsersPage(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(body: Center(child: Text('404 - الصفحة غير موجودة'))),
        );
    }
  }
}