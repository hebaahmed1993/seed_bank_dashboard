enum SectionFilterType {
  latest('latest', 'الأحدث'),
  bestSeller('best_seller', 'الأكثر مبيعاً'),
  offers('offers', 'العروض');

  final String value; // القيمة التي تُحفظ في Firestore
  final String label; // القيمة التي تظهر للمستخدم

  const SectionFilterType(this.value, this.label);

  /// دالة للتحويل من نص (قاعدة بيانات) إلى Enum
  static SectionFilterType fromValue(String? value) {
    return SectionFilterType.values.firstWhere(
          (e) => e.value == value,
      orElse: () => SectionFilterType.latest, // افتراضي
    );
  }
}