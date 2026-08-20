



import 'package:cloud_firestore/cloud_firestore.dart';

class CancelReasonModel {
  final bool isActive;
  final String reasonAr;
  final String reasonId;

  CancelReasonModel({
    required this.isActive,
    required this.reasonAr,
    required this.reasonId,
  });
// إضافة دالة من Firestore
  factory CancelReasonModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return CancelReasonModel(
      isActive: map['isActive'] ?? false,
      reasonAr: map['reasonAr'] ?? '',
      reasonId: map['reasonId'] ?? doc.id,
    );
  }

  // إضافة دالة إلى Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'isActive': isActive,
      'reasonAr': reasonAr,
      'reasonId': reasonId,
    };
  }
  // تحويل البيانات من Firestore
  factory CancelReasonModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CancelReasonModel(
      isActive: map['isActive'] ?? false,
      reasonAr: map['reasonAr'] ?? '',
      // نستخدم documentId كخيار احتياطي إذا لم يكن reasonId موجوداً داخل الوثيقة
      reasonId: map['reasonId'] ?? documentId,
    );
  }

  // تحويل البيانات لرفعها إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'isActive': isActive,
      'reasonAr': reasonAr,
      'reasonId': reasonId,
    };
  }

  // إضافة copyWith لتسهيل التعديل على الحالة (مهم للـ Riverpod)
  CancelReasonModel copyWith({
    bool? isActive,
    String? reasonAr,
    String? reasonId,
  }) {
    return CancelReasonModel(
      isActive: isActive ?? this.isActive,
      reasonAr: reasonAr ?? this.reasonAr,
      reasonId: reasonId ?? this.reasonId,
    );
  }
}