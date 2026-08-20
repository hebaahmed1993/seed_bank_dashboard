import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/sidebar_header.dart';
import 'widgets/sidebar_item_widget.dart';
import 'widgets/home_overview_view.dart';
import 'widgets/top_app_bar.dart';
import '../../../../core/enums/dashboard_tab.dart'; // تأكدي من مسار هذا الملف
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/theme/theme_provider.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../inventory/presentation/pages/inventory_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../suppliers/presentation/pages/suppliers_page.dart';
import '../../../users/presentation/pages/users_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
// 🎯 1. استدعاء صفحة أقسام الرئيسية الجديدة
import '../../../storefront/presentation/pages/home_sections_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  DashboardTab _currentTab = DashboardTab.home;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sidebarWidth = 0.15.sw.clamp(200.w, 250.w);

    final themeState = ref.watch(themeModeProvider);
    final Color sidebarColor = themeState.primaryColor;
    final Color mainBackgroundColor = themeState.backgroundColor;
    final Color surfaceColor = themeState.surfaceColor;

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Row(
        children: [
          Container(
            width: sidebarWidth,
            color: sidebarColor,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 1.sh),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SidebarHeaderWidget(platformTitle: l10n.platformTitle),
                      SizedBox(height: 10.h),

                      SidebarItemWidget(
                        icon: Icons.dashboard_outlined,
                        title: l10n.homeMenu,
                        isActive: _currentTab == DashboardTab.home,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.home),
                      ),

                      SidebarItemWidget(
                        icon: Icons.view_carousel_outlined,
                        title: 'واجهة التطبيق',
                        isActive: _currentTab == DashboardTab.storefront,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () => setState(
                                () => _currentTab = DashboardTab.storefront),
                      ),

                      SidebarItemWidget(
                        icon: Icons.inventory_2_outlined,
                        title: l10n.plantsMenu,
                        isActive: _currentTab == DashboardTab.plants,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.plants),
                      ),
                      SidebarItemWidget(
                        icon: Icons.category_outlined,
                        title: 'التصنيفات',
                        isActive: _currentTab == DashboardTab.categories,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () => setState(
                                () => _currentTab = DashboardTab.categories),
                      ),
                      SidebarItemWidget(
                        icon: Icons.warehouse_outlined,
                        title: 'إدارة المخزون',
                        isActive: _currentTab == DashboardTab.inventory,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () => setState(
                                () => _currentTab = DashboardTab.inventory),
                      ),
                      SidebarItemWidget(
                        icon: Icons.local_shipping_outlined,
                        title: 'الموردين',
                        isActive: _currentTab == DashboardTab.suppliers,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () => setState(
                                () => _currentTab = DashboardTab.suppliers),
                      ),
                      SidebarItemWidget(
                        icon: Icons.people_outline,
                        title: l10n.usersMenu,
                        isActive: _currentTab == DashboardTab.users,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.users),
                      ),
                      SidebarItemWidget(
                        icon: Icons.shopping_bag_outlined,
                        title: l10n.ordersMenu,
                        isActive: _currentTab == DashboardTab.orders,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.orders),
                      ),
                      SidebarItemWidget(
                        icon: Icons.bar_chart_outlined,
                        title: l10n.reportsMenu,
                        isActive: _currentTab == DashboardTab.reports,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.reports),
                      ),
                      SidebarItemWidget(
                        icon: Icons.settings_outlined,
                        title: l10n.settingsMenu,
                        isActive: _currentTab == DashboardTab.settings,
                        sidebarColor: sidebarColor,
                        mainBgColor: mainBackgroundColor,
                        onTap: () =>
                            setState(() => _currentTab = DashboardTab.settings),
                      ),

                      const Spacer(),

                      // زر تسجيل الخروج
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.h, right: 16.w),
                        child: ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white70,
                            size: 24.sp,
                          ),
                          title: Text(
                            l10n.logoutButton,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopAppBarWidget(
                  welcomeMessage: l10n.welcomeMessage,
                  backgroundColor: surfaceColor,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _buildCurrentBody(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBody() {
    switch (_currentTab) {
      case DashboardTab.home:
        return const HomeOverviewView();
      case DashboardTab.storefront:
        return const HomeSectionsPage();
      case DashboardTab.plants:
        return const ProductsPage();
      case DashboardTab.categories:
        return const CategoriesPage();
      case DashboardTab.inventory:
        return const InventoryPage();
      case DashboardTab.suppliers:
        return const SuppliersPage();
      case DashboardTab.users:
        return const UsersPage();
      case DashboardTab.orders:
        return const OrdersPage();
      case DashboardTab.settings:
        return const SettingsPage();
      default:
        return Center(
          child: Text(
            'هذه الشاشة قيد التطوير حالياً ⚙️',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
          ),
        );
    }
  }
}

