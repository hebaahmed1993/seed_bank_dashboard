import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/custom_switch.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class AlertsSettingsTab extends StatefulWidget {
  const AlertsSettingsTab({super.key});

  @override
  State<AlertsSettingsTab> createState() => _AlertsSettingsTabState();
}

class _AlertsSettingsTabState extends State<AlertsSettingsTab> {
  // محركات التحكم (Controllers)
  final _lowStockThresholdController = TextEditingController(text: "10");
  final _maxOrderQtyController = TextEditingController(text: "50");
  final _seasonAlertDaysController = TextEditingController(text: "14");

  // مفاتيح التفعيل (Switches)
  bool _sendLowStockAlerts = true;
  bool _autoHideOutOfStock = false;
  bool _soundNotifications = true;
  bool _pushNotifications = false;
  bool _emailDailyDigest = true;

  @override
  void dispose() {
    _lowStockThresholdController.dispose();
    _maxOrderQtyController.dispose();
    _seasonAlertDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      key: const ValueKey("alerts_settings_tab"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. لافتة "قيد التطوير" (Under Development Banner)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.construction, color: Colors.amber[800], size: 24.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "هذه الخصائص المتقدمة قيد التطوير حالياً. يمكنك تصفح الواجهة وتجربة الخيارات، ولكن لن يتم حفظها في قاعدة البيانات حتى اكتمال البرمجة الخلفية.",
                    style: TextStyle(
                      color: Colors.amber[900],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // 2. القسم الأول: إعدادات وسلوك المخزون
          _buildSectionCard(
            context: context,
            title: "إعدادات وسلوك المخزون",
            icon: Icons.inventory_2_outlined,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _lowStockThresholdController,
                      labelText: "حد المخزون المنخفض (قطع)",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _maxOrderQtyController,
                      labelText: "الحد الأقصى للطلب الواحد",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _seasonAlertDaysController,
                      labelText: "تنبيه قبل انتهاء الموسم (أيام)",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              CustomSwitch(
                title: "إخفاء المنتجات المنتهية تلقائياً",
                subtitle: "إخفاء المنتج من منصة المستخدمين فور وصول مخزونه إلى 0 بدلاً من عرض (نفدت الكمية).",
                value: _autoHideOutOfStock,
                onChanged: (val) => setState(() => _autoHideOutOfStock = val),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // 3. القسم الثاني: إدارة التنبيهات والإشعارات
          _buildSectionCard(
            context: context,
            title: "إدارة التنبيهات والإشعارات",
            icon: Icons.notifications_active_outlined,
            children: [
              CustomSwitch(
                title: "التنبيهات الصوتية للطلبات الجديدة",
                subtitle: "تشغيل نغمة تنبيه تلقائية فور وصول طلب جديد للوحة التحكم.",
                value: _soundNotifications,
                onChanged: (val) => setState(() => _soundNotifications = val),
              ),
              Divider(height: 32.h, color: colorScheme.outline.withValues(alpha: 0.2)),
              CustomSwitch(
                title: "إشعارات المتصفح المنبثقة (Push Notifications)",
                subtitle: "عرض إشعار في زاوية الشاشة عند نفاد مخزون أو وصول طلب حتى لو كانت اللوحة في الخلفية.",
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              Divider(height: 32.h, color: colorScheme.outline.withValues(alpha: 0.2)),
              CustomSwitch(
                title: "ملخص البريد الإلكتروني اليومي",
                subtitle: "إرسال تقرير يومي للمديرين يحتوي على ملخص المبيعات وحالة المخزون.",
                value: _emailDailyDigest,
                onChanged: (val) => setState(() => _emailDailyDigest = val),
              ),
              Divider(height: 32.h, color: colorScheme.outline.withValues(alpha: 0.2)),
              CustomSwitch(
                title: "تنبيهات انخفاض المخزون الفورية",
                subtitle: "إرسال إشعار فوري عند وصول كمية البذور للحد المنخفض المحدد أعلاه.",
                value: _sendLowStockAlerts,
                onChanged: (val) => setState(() => _sendLowStockAlerts = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // أداة مساعدة لبناء البطاقات (Cards) لتنظيم الواجهة
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.02),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }
}