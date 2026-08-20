class RegionModel {
  final String regionId;
  final String cityId;
  final String name;
  final double baseFee;
  final String estimatedDays;
  final bool isAvailable;
  final String? cityName; // حقل مساعد لعرض اسم المدينة في الجدول برمجياً

  RegionModel({
    required this.regionId,
    required this.cityId,
    required this.name,
    required this.baseFee,
    required this.estimatedDays,
    required this.isAvailable,
    this.cityName,
  });

  factory RegionModel.fromFirestore(Map<String, dynamic> json, {String? cityName}) {
    return RegionModel(
      regionId: json['regionId'] ?? '',
      cityId: json['cityId'] ?? '',
      name: json['name'] ?? '',
      baseFee: (json['baseFee'] ?? 0).toDouble(),
      estimatedDays: json['estimatedDays'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      cityName: cityName,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'regionId': regionId,
      'cityId': cityId,
      'name': name,
      'baseFee': baseFee,
      'estimatedDays': estimatedDays,
      'isAvailable': isAvailable,
    };
  }

  RegionModel copyWith({
    String? regionId,
    String? cityId,
    String? name,
    double? baseFee,
    String? estimatedDays,
    bool? isAvailable,
    String? cityName,
  }) {
    return RegionModel(
      regionId: regionId ?? this.regionId,
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      baseFee: baseFee ?? this.baseFee,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      isAvailable: isAvailable ?? this.isAvailable,
      cityName: cityName ?? this.cityName,
    );
  }
}