class CityModel {
  final String cityId;
  final bool isActive;
  final String name;


  CityModel({
    required this.cityId,
    required this.isActive,
    required this.name,

  });

  // من قاعدة البيانات Firestore إلى الكائن البرمجي
  factory CityModel.fromFirestore(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['cityId'] ?? '',
      isActive: json['isActive'] ?? false,
      name: json['name'] ?? '',
    );
  }

  // من الكائن البرمجي إلى خريطة Firestore للحفظ أو التحديث
  Map<String, dynamic> toFirestore() {
    return {
      'cityId': cityId,
      'isActive': isActive,
      'name': name,
    };
  }

  // دالة المساعدة لتسهيل عملية التحديث وتغيير قيم محددة فقط
  CityModel copyWith({
    String? cityId,
    bool? isActive,
    String? name,
  }) {
    return CityModel(
      cityId: cityId ?? this.cityId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
    );
  }
}