import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../../../core/params/pagination_params.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<Map<String, dynamic>> getProductsPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? categoryId,
  });
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id, String categoryId);

  // 🎯 تعريف الدالة لتغيير الحالة
  Future<void> toggleProductStatus(String id, bool isActive);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductsRemoteDataSourceImpl(this._firestore);

  // 🎯 تطبيق دالة تغيير الحالة
  @override
  Future<void> toggleProductStatus(String id, bool isActive) async {
    try {
      await _firestore.collection('products').doc(id).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('🔥 خطأ في تغيير حالة المنتج: $e');
      throw Exception('فشل تغيير حالة المنتج: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProductsPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? categoryId,
  }) async {
    try {
      Query query = _firestore.collection('products');

      // 1. تطبيق فلتر التصنيف
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
        query = query.where('categoryId', isEqualTo: categoryId);
      }

      // 2. الاستعلام الديناميكي للبحث
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchTerm = searchQuery.trim();
        // البحث بالبادئة (Prefix)
        query = query
            .orderBy('name')
            .startAt([searchTerm])
            .endAt(['$searchTerm\uf8ff']);
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      // 3. تطبيق الـ Cursor والـ Limit للصفحات
      if (paginationParams.action == PaginationAction.next && paginationParams.lastDoc != null) {
        query = query.startAfterDocument(paginationParams.lastDoc!).limit(paginationParams.limit);
      } else if (paginationParams.action == PaginationAction.previous && paginationParams.firstDoc != null) {
        query = query.endBeforeDocument(paginationParams.firstDoc!).limitToLast(paginationParams.limit);
      } else {
        query = query.limit(paginationParams.limit);
      }

      final QuerySnapshot snapshot = await query.get();
      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return {
        'products': products,
        'firstDoc': snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
        'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        'hasNextPage': snapshot.docs.length == paginationParams.limit,
      };
    } catch (e) {
      debugPrint('🔥 خطأ في جلب المنتجات: $e');
      throw Exception('فشل جلب المنتجات: $e');
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final batch = _firestore.batch();
      final productRef = _firestore.collection('products').doc();
      final updatedProduct = product.copyWith(
        id: productRef.id,
        createdAt: DateTime.now(),
      );
      batch.set(productRef, updatedProduct.toFirestore());

      if (product.categoryId.isNotEmpty) {
        final categoryRef = _firestore.collection('categories').doc(product.categoryId);
        batch.update(categoryRef, {'product_count': FieldValue.increment(1)});
      }

      await batch.commit();
    } catch (e) {
      debugPrint('🔥 خطأ في إضافة المنتج: $e');
      throw Exception('فشل إضافة المنتج: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).update(product.toFirestore());
    } catch (e) {
      debugPrint('🔥 خطأ في تحديث المنتج: $e');
      throw Exception('فشل تحديث المنتج: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id, String categoryId) async {
    try {
      final batch = _firestore.batch();
      batch.delete(_firestore.collection('products').doc(id));

      if (categoryId.isNotEmpty) {
        final categoryRef = _firestore.collection('categories').doc(categoryId);
        batch.update(categoryRef, {'product_count': FieldValue.increment(-1)});
      }

      await batch.commit();
    } catch (e) {
      debugPrint('🔥 خطأ في حذف المنتج: $e');
      throw Exception('فشل حذف المنتج: $e');
    }
  }
}