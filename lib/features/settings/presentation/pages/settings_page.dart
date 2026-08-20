import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:seed_bank_dashboard/features/settings/presentation/pages/widgets/app_settings_view.dart';
import 'package:seed_bank_dashboard/features/settings/presentation/pages/widgets/alerts_settings_tab.dart';
import 'package:seed_bank_dashboard/features/orders/presentation/pages/widgets/cancellation_reasons/cancellation_reasons_tab.dart';
import 'package:seed_bank_dashboard/features/orders/presentation/pages/widgets/order_statuses/order_statuses_tab.dart';
import 'package:seed_bank_dashboard/features/settings/presentation/pages/widgets/general_settings_tab.dart';

import '../../../../core/theme/theme/theme_provider.dart';
import '../../../../core/theme/theme/app_constants.dart';
import '../../../locations/presentation/pages/widgets/cities/cities_delivery_tab.dart';
import '../../../locations/presentation/pages/widgets/regions/regions_delivery_tab.dart';
import '../../../staff/presentation/pages/staff_permissions_tab.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int _activeTabIndex = 0; // التبويب النشط حالياً

  // محركات التحكم بحقول الإدخال
  final _lowStockThresholdController = TextEditingController(text: "10");

  // حالات المفاتيح الثنائية لتبويبات المتجر والتنبيهات
  bool _sendLowStockAlerts = true;
  bool _soundNotifications = true;

  @override
  void dispose() {
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 الاستماع للحالة المركزية للثيم
    final themeState = ref.watch(themeModeProvider);
    final currentPrimaryColor = themeState.primaryColor;
    final surfaceColor = themeState.surfaceColor; // لون الكروت والأسطح

    // ألوان مساعدة من الثيم الحالي للنصوص والحدود
    final colorScheme = Theme.of(context).colorScheme;
    final outlineColor = colorScheme.outline.withValues(alpha: 0.2);
    final unselectedTextColor = colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. قائمة التبويبات الجانبية (Sidebar Tabs)
          Container(
            width: 280.w,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: outlineColor), // 🎯 حدود ناعمة
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: StaticData.settingsTabs.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.h, color: outlineColor),
              itemBuilder: (context, index) {
                final isSelected = _activeTabIndex == index;
                final tabData = StaticData.settingsTabs[index];

                return ListTile(
                  leading: Icon(
                    tabData["icon"] as IconData,
                    size: 22.sp,
                    // 🎯 لون الأيقونة حسب التحديد
                    color: isSelected
                        ? currentPrimaryColor
                        : unselectedTextColor,
                  ),
                  title: Text(
                    tabData["title"] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      // 🎯 لون النص حسب التحديد
                      color: isSelected
                          ? currentPrimaryColor
                          : unselectedTextColor,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          themeState.languageCode.languageCode == 'ar'
                              ? Icons.arrow_back_ios_new
                              : Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: currentPrimaryColor,
                        )
                      : null,
                  selected: isSelected,
                  selectedTileColor: currentPrimaryColor.withValues(
                    alpha: 0.05,
                  ),
                  onTap: () {
                    setState(() {
                      _activeTabIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(width: 24.w),

          // 2. منطقة عرض التبويب النشط
          Expanded(
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(28.r),
              decoration: BoxDecoration(
                color: surfaceColor, // 🎯 استخدام لون السطح
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: outlineColor),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildActiveTabContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // توجيه المحتوى حسب التبويب النشط
  Widget _buildActiveTabContent() {
    switch (_activeTabIndex) {
      case 0:
        return const CitiesDeliveryTab();
      case 1:
        return const RegionsDeliveryTab();
      case 2:
        return AlertsSettingsTab();
      case 3:
        return const CancellationReasonsTab();
      case 4:
        return const OrderStatusesTab();
      case 5:
        return const StaffPermissionsTab();
      case 6:
        return const AppSettingsView();
      case 7:
        return const GeneralSettingsTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
