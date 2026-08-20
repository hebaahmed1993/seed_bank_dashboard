enum SelectionMode {
  dynamicMode('dynamic', 'ديناميكي'),
  manual('manual', 'يدوي');

  final String value; // القيمة التي تُحفظ وتُقرأ من قاعدة البيانات (Firestore)
  final String label; // القيمة المعروضة للمستخدم في الواجهة (UI)

  const SelectionMode(this.value, this.label);

  /// دالة مساعدة لتحويل النص القادم من قاعدة البيانات إلى Enum بأمان
  static SelectionMode fromValue(String? val) {
    return SelectionMode.values.firstWhere(
          (e) => e.value == val,
      orElse: () => SelectionMode.manual, // القيمة الافتراضية في حال وجود خطأ
    );
  }
}