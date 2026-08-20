class StatisticsModel {
  // --- الإحصائيات العامة (الشاملة / All-Time) ---
  final int totalProducts;
  final int totalSuppliers; // 🎯 إضافة إجمالي الموردين
  final int totalUsers;
  final int totalOrders;    // 🎯 إضافة إجمالي الطلبات الكلية
  final int activeOrders;   // الطلبات النشطة حالياً في النظام

  // --- إحصائيات وأداء هذا الشهر (Monthly Analytics) ---
  final int monthlyCompletedOrders; // الطلبات المسلمة هذا الشهر
  final int monthlyCancelledOrders; // الطلبات الملغية هذا الشهر
  final double monthlyEarnings;     // أرباح هذا الشهر (إذا رغبت بتفعيلها لاحقاً)

  final DateTime reportMonth;

  const StatisticsModel({
    required this.totalProducts,
    required this.totalSuppliers,
    required this.totalUsers,
    required this.totalOrders,
    required this.activeOrders,
    required this.monthlyCompletedOrders,
    required this.monthlyCancelledOrders,
    required this.monthlyEarnings,
    required this.reportMonth,
  });

  factory StatisticsModel.empty() {
    final now = DateTime.now();
    return StatisticsModel(
      totalProducts: 0,
      totalSuppliers: 0,
      totalUsers: 0,
      totalOrders: 0,
      activeOrders: 0,
      monthlyCompletedOrders: 0,
      monthlyCancelledOrders: 0,
      monthlyEarnings: 0.0,
      reportMonth: DateTime(now.year, now.month, 1),
    );
  }

  StatisticsModel copyWith({
    int? totalProducts,
    int? totalSuppliers,
    int? totalUsers,
    int? totalOrders,
    int? activeOrders,
    int? monthlyCompletedOrders,
    int? monthlyCancelledOrders,
    double? monthlyEarnings,
    DateTime? reportMonth,
  }) {
    return StatisticsModel(
      totalProducts: totalProducts ?? this.totalProducts,
      totalSuppliers: totalSuppliers ?? this.totalSuppliers,
      totalUsers: totalUsers ?? this.totalUsers,
      totalOrders: totalOrders ?? this.totalOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      monthlyCompletedOrders: monthlyCompletedOrders ?? this.monthlyCompletedOrders,
      monthlyCancelledOrders: monthlyCancelledOrders ?? this.monthlyCancelledOrders,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
      reportMonth: reportMonth ?? this.reportMonth,
    );
  }
}