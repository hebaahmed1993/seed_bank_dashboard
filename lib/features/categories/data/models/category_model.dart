class CategoryModel {
  final String id;
  final int level;
  final String name;
  final String? parentId;
  final int sortOrder;
  final int productCount; // إضافة المتغير الجديد

  const CategoryModel({
    required this.id,
    required this.level,
    required this.name,
    this.parentId,
    required this.sortOrder,
    required this.productCount, // إضافة للمنشئ
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return CategoryModel(
      id: documentId,
      level: json['level'] as int? ?? 1,
      name: json['name'] ?? '',
      parentId: json['parentId'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      productCount: json['product_count'] as int? ?? 0, // جلب البيانات من Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'level': level,
      'name': name,
      'parentId': parentId,
      'sortOrder': sortOrder,
      'product_count': productCount, // إرسال البيانات للـ Firestore
    };
  }

  CategoryModel copyWith({
    String? id,
    int? level,
    String? name,
    String? parentId,
    int? sortOrder,
    int? productCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      level: level ?? this.level,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      productCount: productCount ?? this.productCount,
    );
  }
}