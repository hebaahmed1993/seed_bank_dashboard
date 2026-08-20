import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/home_section_type.dart';
import '../../../../core/enums/section_filter_type.dart';
import '../../../../core/enums/selection_mode.dart';

const _sentinel = Object();

class HomeSectionModel {
  final String id;
  final String title;
  final int order;
  final bool isActive;
  final HomeSectionType type; // 🎯 نوع القسم (منتجات، إعلان، تصنيفات)

  // حقول خاصة بالمنتجات
  final SelectionMode? selectionMode;
  final SectionFilterType? dynamicFilterType;
  final List<String> productIds;

  // 🎯 حقول خاصة بالتصنيفات
  final List<String> categoryIds;

  final int limit;

  // 🎯 حقول خاصة بالإعلانات
  final String? imageUrl;
  final String? targetUrl;

  final DateTime createdAt;

  const HomeSectionModel({
    required this.id,
    required this.title,
    required this.order,
    required this.isActive,
    required this.type,
    this.selectionMode,
    this.dynamicFilterType,
    this.productIds = const [],
    this.categoryIds = const [],
    this.limit = 10,
    this.imageUrl,
    this.targetUrl,
    required this.createdAt,
  });

  factory HomeSectionModel.fromFirestore(
      Map<String, dynamic> data,
      String documentId,
      ) {
    return HomeSectionModel(
      id: documentId,
      title: data['title'] as String? ?? '',
      order: data['order'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      type: HomeSectionType.fromValue(data['type'] as String? ?? 'products'),
      selectionMode: data['selectionMode'] != null
          ? SelectionMode.fromValue(data['selectionMode'])
          : SelectionMode.dynamicMode,
      dynamicFilterType: data['dynamicFilterType'] != null
          ? SectionFilterType.fromValue(data['dynamicFilterType'] as String?)
          : null,
      productIds: List<String>.from(data['productIds'] as List? ?? []),
      categoryIds: List<String>.from(data['categoryIds'] as List? ?? []),
      limit: data['limit'] as int? ?? 10,
      imageUrl: data['imageUrl'] as String?,
      targetUrl: data['targetUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'order': order,
      'isActive': isActive,
      'type': type.value,
      // حفظ بيانات المنتجات
      'selectionMode': type == HomeSectionType.products ? selectionMode?.value : null,
      'dynamicFilterType': type == HomeSectionType.products ? dynamicFilterType?.value : null,
      'productIds': type == HomeSectionType.products ? productIds : [],
      // 🎯 حفظ بيانات التصنيفات
      'categoryIds': type == HomeSectionType.categories ? categoryIds : [],
      // الحد الأقصى للمنتجات والتصنيفات
      'limit': (type == HomeSectionType.products || type == HomeSectionType.categories) ? limit : 10,
      // حفظ بيانات الإعلانات
      'imageUrl': type == HomeSectionType.banner ? imageUrl : null,
      'targetUrl': type == HomeSectionType.banner ? targetUrl : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  HomeSectionModel copyWith({
    String? id,
    String? title,
    int? order,
    bool? isActive,
    HomeSectionType? type,
    SelectionMode? selectionMode,
    Object? dynamicFilterType = _sentinel,
    List<String>? productIds,
    List<String>? categoryIds,
    int? limit,
    Object? imageUrl = _sentinel,
    Object? targetUrl = _sentinel,
    DateTime? createdAt,
  }) {
    return HomeSectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      selectionMode: selectionMode ?? this.selectionMode,
      dynamicFilterType: dynamicFilterType == _sentinel
          ? this.dynamicFilterType
          : dynamicFilterType as SectionFilterType?,
      productIds: productIds ?? this.productIds,
      categoryIds: categoryIds ?? this.categoryIds,
      limit: limit ?? this.limit,
      imageUrl: imageUrl == _sentinel ? this.imageUrl : imageUrl as String?,
      targetUrl: targetUrl == _sentinel ? this.targetUrl : targetUrl as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}