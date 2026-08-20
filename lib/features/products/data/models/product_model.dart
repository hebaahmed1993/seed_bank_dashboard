import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String description;
  final int? germinationRate;
  final String season;
  final bool isActive;
  final String? sku;
  final int lowStockThreshold;
  final bool hasExpiryTracking;
  final String? defaultSupplierId;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    required this.description,
    this.germinationRate,
    required this.season,
    this.isActive = false,
    this.sku,
    this.lowStockThreshold = 10,
    this.hasExpiryTracking = false,
    this.defaultSupplierId,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    double? price,
    int? stockQuantity,
    String? imageUrl,
    String? description,
    int? germinationRate,
    String? season,
    bool? isActive,
    String? sku,
    int? lowStockThreshold,
    bool? hasExpiryTracking,
    String? defaultSupplierId,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      germinationRate: germinationRate ?? this.germinationRate,
      season: season ?? this.season,
      isActive: isActive ?? this.isActive,
      sku: sku ?? this.sku,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      hasExpiryTracking: hasExpiryTracking ?? this.hasExpiryTracking,
      defaultSupplierId: defaultSupplierId ?? this.defaultSupplierId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProductModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        parsedPrice = double.tryParse(json['price'] as String) ?? 0.0;
      }
    }

    int parsedStock = 0;
    final stockValue = json['stockQuantity'] ?? json['stock'];
    if (stockValue != null) {
      if (stockValue is int) {
        parsedStock = stockValue;
      } else if (stockValue is num) {
        parsedStock = stockValue.toInt();
      } else if (stockValue is String) {
        parsedStock = int.tryParse(stockValue) ?? 0;
      }
    }

    int? parsedGermination;
    if (json['germinationRate'] != null) {
      if (json['germinationRate'] is int) {
        parsedGermination = json['germinationRate'] as int;
      } else if (json['germinationRate'] is num) {
        parsedGermination = (json['germinationRate'] as num).toInt();
      } else if (json['germinationRate'] is String) {
        parsedGermination = int.tryParse(json['germinationRate'] as String);
      }
    }

    DateTime parsedCreatedAt = DateTime.now();
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Timestamp) {
        parsedCreatedAt = (json['createdAt'] as Timestamp).toDate();
      } else if (json['createdAt'] is String) {
        parsedCreatedAt = DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now();
      }
    }

    return ProductModel(
      id: documentId,
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      price: parsedPrice,
      stockQuantity: parsedStock,
      imageUrl: (json['imageUrl'] as String?)?.isEmpty ?? true ? null : json['imageUrl'],
      description: json['description'] ?? '',
      germinationRate: parsedGermination,
      season: json['season'] ?? 'all',
      isActive: json['isActive'] ?? false,
      sku: json['sku'] as String?,
      lowStockThreshold: json['lowStockThreshold'] as int? ?? 10,
      hasExpiryTracking: json['hasExpiryTracking'] as bool? ?? false,
      defaultSupplierId: json['defaultSupplierId'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl ?? '',
      'description': description,
      'germinationRate': germinationRate,
      'season': season,
      'isActive': isActive,
      'sku': sku,
      'lowStockThreshold': lowStockThreshold,
      'hasExpiryTracking': hasExpiryTracking,
      'defaultSupplierId': defaultSupplierId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}