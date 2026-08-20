import 'package:flutter/material.dart';

enum MovementType {
  inStock,    // إضافة / تزويد
  outStock,   // سحب / مبيعات
  damaged,    // تالف
  adjustment; // تسوية جرد يدوية

  /// إرجاع النص العربي المناسب لكل حالة لسهولة عرضه في الواجهة
  String get nameAr {
    switch (this) {
      case MovementType.inStock:
        return 'إضافة للمخزون';
      case MovementType.outStock:
        return 'سحب / بيع';
      case MovementType.damaged:
        return 'تالف';
      case MovementType.adjustment:
        return 'تسوية جرد';
    }
  }

  /// إرجاع اللون المناسب لكل حالة لاستخدامه في الجداول والرسوم البيانية
  Color get color {
    switch (this) {
      case MovementType.inStock:
        return Colors.green;
      case MovementType.outStock:
        return Colors.orange;
      case MovementType.damaged:
        return Colors.red;
      case MovementType.adjustment:
        return Colors.blue;
    }
  }

  /// دالة مساعدة لتحويل النص القادم من Firebase إلى قيمة Enum برمجية
  static MovementType fromString(String value) {
    return MovementType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => MovementType.adjustment, // قيمة افتراضية آمنة
    );
  }
}