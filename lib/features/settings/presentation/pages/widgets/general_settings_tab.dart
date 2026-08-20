import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/theme/theme/theme_provider.dart';
import '../../../../../core/theme/theme/app_constants.dart';
import '../../../../../core/enums/app_theme_mode.dart';
import '../../../../../core/widgets/custom_dropdown_form_field.dart';

class GeneralSettingsTab extends ConsumerStatefulWidget {
  const GeneralSettingsTab({super.key});

  @override
  ConsumerState<GeneralSettingsTab> createState() => _GeneralSettingsTabState();
}

class _GeneralSettingsTabState extends ConsumerState<GeneralSettingsTab> {
  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeModeProvider);

    return Column(
      key: const ValueKey(4),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الإعدادات العامة للنظام",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.h),

        // 1. لغة النظام (معتمدة مركزياً من الـ themeModeProvider)
        CustomDropdownFormField<String>(
          value: themeState.languageCode.languageCode,
          labelText: "لغة لوحة التحكم الافتراضية",
          items: StaticData.supportedLanguages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang.code,
              child: Text(lang.name),
            );
          }).toList(),
          onChanged: (String? newLang) {
            if (newLang != null) {
              ref.read(themeModeProvider.notifier).setLanguage(newLang);
            }
          },
        ),
        SizedBox(height: 24.h),

        // 2. مظهر الواجهة (Theme)
        CustomDropdownFormField<AppThemeMode>(
          value: themeState.themeMode,
          labelText: "مظهر الواجهة (Theme)",
          items: const [
            DropdownMenuItem(
              value: AppThemeMode.light,
              child: Text("الوضع الفاتح (Light Mode)"),
            ),
            DropdownMenuItem(
              value: AppThemeMode.dark,
              child: Text("الوضع الداكن (Dark Mode)"),
            ),
          ],
          onChanged: (AppThemeMode? newTheme) {
            if (newTheme != null) {
              ref.read(themeModeProvider.notifier).setTheme(newTheme);
            }
          },
        ),
        SizedBox(height: 32.h),

        // 3. لون الهوية
        Text(
          "اللون الرئيسي لهوية المتجر",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Text(
          "اختر اللون الأساسي للمشروع ليتم تطبيقه على الواجهات والأزرار لتناسب علامتك التجارية.",
          style: TextStyle(fontSize: 11.sp, color: AppColors.success),
        ),
        SizedBox(height: 12.h),
        // Row(
        //   children: StaticData.success.map((pair) {
        //     final isSelected = themeState.primaryColor.value == pair.primary.value;
        //
        //     return GestureDetector(
        //       onTap: () async {
        //         // 🎯 تمرير البارامترات الثلاثة الكاملة والمتوافقة مع الـ Notifier
        //         await ref.read(themeModeProvider.notifier).setPrimaryColor(
        //           pair.primary,
        //           pair.background,
        //           pair.textColor,
        //           pair.surface
        //         );
        //       },
        //       child: Container(
        //         margin: EdgeInsets.symmetric(horizontal: 8.w),
        //         width: 44.w,
        //         height: 44.h,
        //         decoration: BoxDecoration(
        //           color: pair.primary,
        //           shape: BoxShape.circle,
        //           border: Border.all(
        //             color: isSelected ? AppColors.onBackground : Colors.transparent,
        //             width: 3.w,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withValues(alpha: 0.1),
        //               blurRadius: 4.r,
        //               offset: Offset(0, 2.h),
        //             ),
        //           ],
        //         ),
        //         child: isSelected
        //             ? Icon(Icons.check, color: pair.textColor, size: 20.sp)
        //             : const SizedBox.shrink(),
        //       ),
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}