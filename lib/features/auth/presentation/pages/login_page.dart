import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme/app_assets.dart';
import '../../../../core/theme/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/button_app.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context); // 🎯 قراءة الثيم النشط حالياً

    // 1. جلب كائن اللغات
    final l10n = AppLocalizations.of(context);

    // 2. تأمين الواجهة
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // الاستماع لحالة النجاح للانتقال إلى الـ Dashboard
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    });

    return Scaffold(
      body: Row(
        children: [
          // الجانب الأيمن لتصميم الويب (شاشات العرض الكبيرة)
          if (MediaQuery.of(context).size.width > 800)
            Expanded(
              child: Container(
                // 🎯 استخدام اللون الرئيسي الديناميكي بشفافية 5% كخلفية بدلاً من primaryContainer
                color: theme.primaryColor.withValues(alpha: 0.05),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppAssets.appLogo(size: 80.0),
                      const SizedBox(height: 16),
                      Text(
                        l10n.platformTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor, // 🎯 يعكس اللون الديناميكي المختار
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.platformSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondaryLight, // 🎯 استخدام النص الفرعي من ألواننا
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // الجانب الأيسر: استمارة تسجيل الدخول
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.login,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryLight, // 🎯 لون العنوان الرئيسي
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginInstruction,
                        style: const TextStyle(color: AppColors.textMuted), // 🎯 اللون الباهت
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // حقل البريد الإلكتروني الموحد
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: l10n.email,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.isEmpty ? l10n.emailRequired : null,
                      ),
                      const SizedBox(height: 16),

                      // حقل كلمة المرور الموحد
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: l10n.password,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? l10n.passwordRequired : null,
                      ),
                      const SizedBox(height: 24),

                      // رسالة الخطأ
                      if (authState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error, // 🎯 الأحمر القياسي من التصميم
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      ButtonApp(
                        text: l10n.loginButton,
                        isLoading: authState.isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(authProvider.notifier).login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}