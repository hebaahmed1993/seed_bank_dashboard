import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel {
  final String id;
  final String accountTypeId;
  final String name;
  final String email;
  final String phone;
  final String? cityId;
  final String? cityName;
  final bool isBlocked;
  final DateTime createdAt;

  // 🎯 الحقل الجديد (مؤقت ولا يُحفظ في قاعدة البيانات)
  final String? password;

  StaffModel({
    required this.id,
    required this.accountTypeId,
    required this.name,
    required this.email,
    required this.phone,
    this.cityId,
    this.cityName,
    required this.isBlocked,
    required this.createdAt,
    this.password, // 🎯
  });

  factory StaffModel.fromFirestore(Map<String, dynamic> data, String id) {
    return StaffModel(
      id: id,
      accountTypeId: data['accountTypeId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      cityId: data['cityId'],
      cityName: data['cityName'],
      isBlocked: data['isBlocked'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'accountTypeId': accountTypeId,
      'name': name,
      'email': email,
      'phone': phone,
      'cityId': cityId,
      'cityName': cityName,
      'isBlocked': isBlocked,
      'createdAt': Timestamp.fromDate(createdAt),
      // 🚫 احذري أن تضعي كلمة المرور هنا!
    };
  }

  StaffModel copyWith({
    String? id,
    String? accountTypeId,
    String? name,
    String? email,
    String? phone,
    String? cityId,
    String? cityName,
    bool? isBlocked,
    DateTime? createdAt,
    String? password,
  }) {
    return StaffModel(
      id: id ?? this.id,
      accountTypeId: accountTypeId ?? this.accountTypeId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }
}