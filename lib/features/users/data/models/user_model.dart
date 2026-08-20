import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String accountTypeId;
  final String cityId;
  final String cityName; // 🎯 الحقل الجديد
  final bool isBlocked;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.accountTypeId,
    required this.cityId,
    required this.cityName, // 🎯
    required this.isBlocked,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedCreatedAt;
    final rawDate = json['createdAt'];
    if (rawDate is Timestamp) {
      parsedCreatedAt = rawDate.toDate();
    } else if (rawDate is String) {
      parsedCreatedAt = DateTime.tryParse(rawDate);
    }

    return UserModel(
      uid: json['uid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      accountTypeId: json['accountTypeId']?.toString() ?? 'user',
      cityId: json['cityId']?.toString() ?? '',
      cityName: json['cityName']?.toString() ?? 'غير محدد', // 🎯 استقبال اسم المدينة
      isBlocked: json['isBlocked'] == true,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'accountTypeId': accountTypeId,
      'cityId': cityId,
      'cityName': cityName, // 🎯
      'isBlocked': isBlocked,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? accountTypeId,
    String? cityId,
    String? cityName,
    bool? isBlocked,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountTypeId: accountTypeId ?? this.accountTypeId,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName, // 🎯
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}