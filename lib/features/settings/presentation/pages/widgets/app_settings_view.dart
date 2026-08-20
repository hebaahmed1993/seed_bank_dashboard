import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/request_status.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/utils/custom_snackbar.dart'; // 🎯 استدعاء السناك بار المخصص
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../data/models/app_settings_model.dart';
import '../../providers/app_settings_provider.dart';

class AppSettingsView extends ConsumerStatefulWidget {
  const AppSettingsView({super.key});

  @override
  ConsumerState<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends ConsumerState<AppSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _appNameController = TextEditingController();
  final _appVersionController = TextEditingController();
  final _currencyCodeController = TextEditingController();
  final _supportPhoneController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _aboutUsController = TextEditingController();
  final _privacyPolicyController = TextEditingController();
  final _termsController = TextEditingController();

  bool _isUnderMaintenance = false;
  bool _hasSyncedInitialData = false;

  @override
  void dispose() {
    _appNameController.dispose();
    _appVersionController.dispose();
    _currencyCodeController.dispose();
    _supportPhoneController.dispose();
    _minOrderController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    _aboutUsController.dispose();
    _privacyPolicyController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme; // 🎯 جلب الثيم

    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final settingsState = ref.watch(appSettingsNotifierProvider);
    final isSaving = settingsState.updateAppSettingsStatus == RequestStatus.loading;

    // 🎯 الاستماع لحالة الحفظ وعرض الإشعارات النظيفة
    ref.listen(appSettingsNotifierProvider, (previous, next) {
      if (previous?.updateAppSettingsStatus != next.updateAppSettingsStatus) {
        if (next.updateAppSettingsStatus == RequestStatus.success) {
          CustomSnackBar.showSuccess(
            context: context,
            message: l10n.settingsSavedSuccess,
          );
        } else if (next.updateAppSettingsStatus == RequestStatus.error) {
          CustomSnackBar.showError(
            context: context,
            message: next.errorMessage ?? l10n.settingsSaveError,
          );
        }
      }
    });

    return settingsAsync.when(
      loading: () => SizedBox(
        height: 420.h,
        child: const Center(child: CustomLoadingIndicator()),
      ),
      error: (error, stackTrace) => _ErrorState(
        message: l10n.errorLoadingSettings,
        details: error.toString(),
      ),
      data: (settings) {
        _syncControllers(settings);

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 96.h),
                  children: [
                    Text(
                      l10n.generalAppSettingsTitle,
                      style: TextStyle(
                        color: colorScheme.onSurface, // 🎯 لون متوافق مع الثيم
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.generalAppSettingsSubtitle,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6), // 🎯 لون متوافق
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _SettingsSection(
                      title: l10n.generalAndOperationSettings,
                      icon: Icons.tune_outlined,
                      child: Column(
                        children: [
                          _ResponsiveFields(
                            children: [
                              CustomTextFormField(
                                controller: _appNameController,
                                labelText: l10n.appNameLabel,
                                hintText: l10n.appNameHint,
                                prefixIcon: Icons.apps_outlined,
                                validator: requiredValidator,
                              ),
                              CustomTextFormField(
                                controller: _appVersionController,
                                labelText: l10n.appVersionLabel,
                                hintText: l10n.appVersionHint,
                                prefixIcon: Icons.new_releases_outlined,
                                validator: requiredValidator,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _ResponsiveFields(
                            children: [
                              CustomTextFormField(
                                controller: _supportPhoneController,
                                labelText: l10n.storeSupportPhoneLabel,
                                hintText: l10n.storeSupportPhoneHint,
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                                ],
                                validator: phoneNumberValidator,
                              ),
                              CustomTextFormField(
                                controller: _minOrderController,
                                labelText: l10n.minOrderValueLabel,
                                hintText: l10n.minOrderValueHint,
                                prefixIcon: Icons.payments_outlined,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                ],
                                validator: priceValidator,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _ResponsiveFields(
                            children: [
                              CustomTextFormField(
                                controller: _currencyCodeController,
                                labelText: l10n.currencyCodeLabel,
                                hintText: l10n.currencyCodeHint,
                                prefixIcon: Icons.currency_exchange_outlined,
                                textInputAction: TextInputAction.next,
                                validator: _currencyValidator,
                              ),
                              _MaintenanceSwitch(
                                value: _isUnderMaintenance,
                                onChanged: isSaving
                                    ? null
                                    : (value) {
                                  setState(() {
                                    _isUnderMaintenance = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _SettingsSection(
                      title: l10n.socialMediaLinksTitle,
                      icon: Icons.share_outlined,
                      child: Column(
                        children: [
                          _ResponsiveFields(
                            children: [
                              CustomTextFormField(
                                controller: _facebookController,
                                labelText: l10n.facebookUrlLabel,
                                hintText: l10n.facebookUrlHint,
                                prefixIcon: Icons.facebook_outlined,
                                keyboardType: TextInputType.url,
                                validator: _urlValidator,
                              ),
                              CustomTextFormField(
                                controller: _instagramController,
                                labelText: l10n.instagramUrlLabel,
                                hintText: l10n.instagramUrlHint,
                                prefixIcon: Icons.camera_alt_outlined,
                                keyboardType: TextInputType.url,
                                validator: _urlValidator,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 420.w,
                              child: CustomTextFormField(
                                controller: _whatsappController,
                                labelText: l10n.whatsappNumberLabel,
                                hintText: l10n.whatsappNumberHint,
                                prefixIcon: Icons.chat_outlined,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                                ],
                                validator: phoneNumberValidator,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _SettingsSection(
                      title: l10n.legalAndIntroPagesTitle,
                      icon: Icons.policy_outlined,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _aboutUsController,
                            labelText: l10n.aboutUsLabel,
                            hintText: l10n.aboutUsHint,
                            prefixIcon: Icons.info_outline,
                            keyboardType: TextInputType.multiline,
                            minLines: 4,
                            maxLines: 7,
                            validator: requiredValidator,
                          ),
                          SizedBox(height: 16.h),
                          _ResponsiveFields(
                            children: [
                              CustomTextFormField(
                                controller: _privacyPolicyController,
                                labelText: l10n.privacyPolicyUrlLabel,
                                hintText: l10n.privacyPolicyUrlHint,
                                prefixIcon: Icons.privacy_tip_outlined,
                                keyboardType: TextInputType.url,
                                validator: _urlValidator,
                              ),
                              CustomTextFormField(
                                controller: _termsController,
                                labelText: l10n.termsUrlLabel,
                                hintText: l10n.termsUrlHint,
                                prefixIcon: Icons.gavel_outlined,
                                keyboardType: TextInputType.url,
                                validator: _urlValidator,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 16.h, bottom: 16.h), // 🎯 ضبط الحواف
                decoration: BoxDecoration(
                  color: colorScheme.surface, // 🎯 إزالة اللون الأخضر
                  border: Border(
                    top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isUnderMaintenance
                            ? l10n.maintenanceModeActive
                            : l10n.changesApplyAfterSave,
                        style: TextStyle(
                          color: _isUnderMaintenance
                              ? AppColors.error // 🎯 استخدام لون تنبيه واضح للصيانة
                              : colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 13.sp,
                          fontWeight: _isUnderMaintenance ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SizedBox(
                      width: 190.w,
                      child: ButtonApp(
                        onPressed: isSaving ? null : _submit,
                        text: l10n.saveSettingsButton,
                        isLoading: isSaving,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _syncControllers(AppSettingsModel settings) {
    if (_hasSyncedInitialData) return;

    _appNameController.text = settings.appName;
    _appVersionController.text = settings.appVersion;
    _currencyCodeController.text = settings.currencyCode;
    _supportPhoneController.text = settings.storePhoneNumber_1;
    _minOrderController.text = settings.minOrderValue;
    _facebookController.text = settings.facebookUrl;
    _instagramController.text = settings.instagramUrl;
    _whatsappController.text = settings.whatsappNumber;
    _aboutUsController.text = settings.aboutUs;
    _privacyPolicyController.text = settings.privacyPolicyUrl;
    _termsController.text = settings.termsAndConditionsUrl;
    _isUnderMaintenance = settings.isUnderMaintenance;
    _hasSyncedInitialData = true;
  }

  // 🎯 إرسال الطلب فقط للـ Notifier بدون await + bool
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final settings = AppSettingsModel(
      aboutUs: _aboutUsController.text.trim(),
      appName: _appNameController.text.trim(),
      appVersion: _appVersionController.text.trim(),
      currencyCode: _currencyCodeController.text.trim().toUpperCase(),
      facebookUrl: _facebookController.text.trim(),
      instagramUrl: _instagramController.text.trim(),
      isUnderMaintenance: _isUnderMaintenance,
      minOrderValue: _minOrderController.text.trim(),
      privacyPolicyUrl: _privacyPolicyController.text.trim(),
      storePhoneNumber_1: _supportPhoneController.text.trim(),
      termsAndConditionsUrl: _termsController.text.trim(),
      whatsappNumber: _whatsappController.text.trim(),
    );

    ref.read(appSettingsNotifierProvider.notifier).updateAppSettings(settings);
  }

  String? _currencyValidator(String? value) {
    final code = value?.trim().toUpperCase() ?? '';
    if (code.isEmpty) return 'يرجى إدخال رمز العملة';
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(code)) {
      return 'رمز العملة يجب أن يتكون من 3 أحرف إنجليزية';
    }
    return null;
  }

  String? _urlValidator(String? value) {
    final text = value?.trim() ?? '';
    final uri = Uri.tryParse(text);
    if (text.isEmpty) return 'يرجى إدخال الرابط';
    if (uri == null || uri.host.isEmpty) {
      return 'رابط غير صحيح';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'يجب أن يبدأ الرابط بـ http أو https';
    }
    return null;
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // 🎯 جلب الثيم

    return Card(
      elevation: 0,
      color: colorScheme.surface, // 🎯 إزالة اللون الأخضر نهائياً
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 22.sp), // 🎯 لون الأيقونة
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface, // 🎯 لون العنوان
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveFields({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) SizedBox(height: 16.h),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) SizedBox(width: 16.w),
            ],
          ],
        );
      },
    );
  }
}

class _MaintenanceSwitch extends ConsumerWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _MaintenanceSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme; // 🎯 جلب الثيم

    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        // 🎯 تلوين ناعم لحالة الصيانة
        color: value ? AppColors.error.withValues(alpha: 0.08) : colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: value ? AppColors.error : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: value ? AppColors.error : colorScheme.primary, // 🎯 ألوان الأيقونات
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              value ? l10n.maintenanceModeActiveStatus : l10n.appWorkingNormally,
              style: TextStyle(
                color: value ? AppColors.error : colorScheme.onSurface, // 🎯 ألوان النصوص
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String details;

  const _ErrorState({
    required this.message,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // 🎯

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 42.sp),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            details,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}