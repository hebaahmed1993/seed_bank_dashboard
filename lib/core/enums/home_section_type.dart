enum HomeSectionType {
  products('products', 'منتجات'),
  banner('banner', 'إعلان (بنر)'),
  categories('categories', 'تصنيفات');

  final String value;
  final String label;

  const HomeSectionType(this.value, this.label);

  static HomeSectionType fromValue(String? val) {
    return HomeSectionType.values.firstWhere(
          (e) => e.value == val,
      orElse: () => HomeSectionType.products,
    );
  }
}