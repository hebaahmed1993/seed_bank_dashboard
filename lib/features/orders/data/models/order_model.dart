import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String productId;
  final String title;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}

class OrderModel {
  final String orderId;
  final DateTime createdAt;
  final String deliveryAddress;
  final double deliveryFee;
  final double grandTotal;
  final double totalPrice;
  final List<OrderItemModel> items;
  final String statusId;
  final String userId;
  final String userName;
  final String userPhone;
  final String? notes;
  final String? cancelReason;

  OrderModel({
    required this.orderId,
    required this.createdAt,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.grandTotal,
    required this.totalPrice,
    required this.items,
    required this.statusId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    this.notes,
    this.cancelReason,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return OrderModel(
      orderId: doc.id,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (data['grandTotal'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      statusId: data['statusId'] ?? 'pending',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      notes: data['notes'],
      cancelReason: data['cancelReason'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'grandTotal': grandTotal,
      'totalPrice': totalPrice,
      'items': items.map((i) => i.toMap()).toList(),
      'statusId': statusId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      if (notes != null) 'notes': notes,
      if (cancelReason != null) 'cancelReason': cancelReason,
    };
  }
}