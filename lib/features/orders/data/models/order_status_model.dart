import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusModel {
  final String statusId;
  final String name;
  final String nameAr;
  final String nameEn;
  final String description;
  final String colorHex;
  final bool isActive;

  OrderStatusModel({
    required this.statusId,
    required this.name,
    this.nameAr = '',
    this.nameEn = '',
    required this.description,
    required this.colorHex,
    required this.isActive,
  });

  factory OrderStatusModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final String nameValue = data['name'] ?? data['nameAr'] ?? '';
    return OrderStatusModel(
      statusId: data['statusId'] ?? doc.id,
      name: nameValue,
      nameAr: data['nameAr'] ?? nameValue,
      nameEn: data['nameEn'] ?? nameValue,
      description: data['description'] ?? '',
      colorHex: data['colorHex'] ?? '#808080',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'statusId': statusId,
      'name': name,
      'nameAr': nameAr.isNotEmpty ? nameAr : name,
      'nameEn': nameEn.isNotEmpty ? nameEn : name,
      'description': description,
      'colorHex': colorHex,
      'isActive': isActive,
    };
  }

  OrderStatusModel copyWith({
    String? statusId,
    String? name,
    String? nameAr,
    String? nameEn,
    String? description,
    String? colorHex,
    bool? isActive,
  }) {
    return OrderStatusModel(
      statusId: statusId ?? this.statusId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
    );
  }
}
