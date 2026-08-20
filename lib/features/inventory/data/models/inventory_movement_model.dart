import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/movement_type.dart';

class InventoryMovementModel {
  final String id;
  final String productId;
  final String? batchId; // اختياري (في حال تفعيل ميزة تاريخ الصلاحية والدفعات لاحقاً)
  final MovementType type; // نوع الحركة باستخدام الـ Enum
  final int quantity; // الكمية المتغيرة (يجب أن تكون قيمة مطلقة دائماً)
  final int previousStock; // الرصيد قبل الحركة
  final int newStock; // الرصيد بعد الحركة
  final String? referenceId; // مرجع الحركة (مثال: رقم الطلبية)
  final String note; // ملاحظات أو سبب الحركة (إلزامي في التالف والتسوية)
  final String createdBy; // معرف المشرف الذي قام بالعملية
  final DateTime createdAt; // وقت وتاريخ الحركة

  const InventoryMovementModel({
    required this.id,
    required this.productId,
    this.batchId,
    required this.type,
    required this.quantity,
    required this.previousStock,
    required this.newStock,
    this.referenceId,
    required this.note,
    required this.createdBy,
    required this.createdAt,
  });

  InventoryMovementModel copyWith({
    String? id,
    String? productId,
    String? batchId,
    MovementType? type,
    int? quantity,
    int? previousStock,
    int? newStock,
    String? referenceId,
    String? note,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return InventoryMovementModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      previousStock: previousStock ?? this.previousStock,
      newStock: newStock ?? this.newStock,
      referenceId: referenceId ?? this.referenceId,
      note: note ?? this.note,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory InventoryMovementModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return InventoryMovementModel(
      id: documentId,
      productId: json['productId'] as String? ?? '',
      batchId: json['batchId'] as String?,
      type: MovementType.fromString(json['type'] as String? ?? 'adjustment'),
      quantity: json['quantity'] as int? ?? 0,
      previousStock: json['previousStock'] as int? ?? 0,
      newStock: json['newStock'] as int? ?? 0,
      referenceId: json['referenceId'] as String?,
      note: json['note'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? 'system',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      if (batchId != null) 'batchId': batchId,
      'type': type.name, // حفظها كنص (String) في قاعدة البيانات
      'quantity': quantity.abs(), // ضمان أن القيمة موجبة دائماً
      'previousStock': previousStock,
      'newStock': newStock,
      if (referenceId != null) 'referenceId': referenceId,
      'note': note,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}