import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String id;
  final String name; // اسم الشخص المسؤول
  final String companyName; // اسم الشركة أو المشتل
  final String phone;
  final String phone2; // رقم الهاتف الثاني
  final String email;
  final String city; // اسم المدينة (Denormalization)
  final String cityId; // معرف المدينة
  final String address; // العنوان التفصيلي
  final bool isActive;
  final DateTime createdAt;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.phone2,
    required this.email,
    required this.city,
    required this.cityId,
    required this.address,
    this.isActive = true,
    required this.createdAt,
  });

  SupplierModel copyWith({
    String? id,
    String? name,
    String? companyName,
    String? phone,
    String? phone2,
    String? email,
    String? city,
    String? cityId,
    String? address,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      email: email ?? this.email,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SupplierModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return SupplierModel(
      id: documentId,
      name: json['name'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      phone2: json['phone2'] as String? ?? '',
      email: json['email'] as String? ?? '',
      city: json['city'] as String? ?? '',
      cityId: json['cityId'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'companyName': companyName,
      'phone': phone,
      'phone2': phone2,
      'email': email,
      'city': city,
      'cityId': cityId,
      'address': address,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}