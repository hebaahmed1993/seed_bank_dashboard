import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../../../core/params/pagination_params.dart';
import '../models/cancel_reason_model.dart';
import '../models/order_model.dart';
import '../models/order_status_model.dart';

abstract class OrdersRemoteDataSource {
  Future<Map<String, dynamic>> getOrdersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? statusFilter,
    String? cityFilter,
    DateTime? startDate,
    DateTime? endDate,
  });
  Stream<List<OrderStatusModel>> getOrderStatuses();
  Stream<List<CancelReasonModel>> getCancelReasons();
  Stream<List<OrderModel>> getRecentProcessingOrdersStream({int limit = 5});

  Future<void> updateOrderStatus({required String orderId, required String statusId, String? notes, String? cancelReason});
  Future<void> addCancelReason(CancelReasonModel reason);
  Future<void> toggleCancelReasonStatus({required String reasonId, required bool isActive});
  Future<void> toggleOrderStatusDetails({required String statusId, required bool isActive});
  Future<void> updateOrderStatusDetails({required String statusId, required String name, String? description, required String colorHex});
  Future<void> addOrderStatus(OrderStatusModel status);
}



class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrdersRemoteDataSourceImpl(this._firestore);




  @override
  Future<Map<String, dynamic>> getOrdersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? statusFilter,
    String? cityFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore.collection('orders');

      // 1. تطبيق فلتر الحالة (إذا لم يكن "الكل")
      if (statusFilter != null && statusFilter != 'all') {
        query = query.where('statusId', isEqualTo: statusFilter);
      }

      // 2. تطبيق فلتر المدينة
      if (cityFilter != null) {
        query = query.where('cityId', isEqualTo: cityFilter);
      }

      // 3. تطبيق فلتر نطاق التاريخ
      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
        query = query.where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
      }

      // 4. الاستعلام الديناميكي (Dynamic Query) للبحث من الخادم
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchTerm = searchQuery.trim();

        // خدعة: إذا كان النص أرقاماً نبحث برقم هاتف العميل، وإذا كان حروفاً نبحث باسم العميل
        final isNumeric = double.tryParse(searchTerm) != null;
        final searchField = isNumeric ? 'userPhone' : 'userName';

        // إلغاء الترتيب الزمني والبحث بالبادئة (Prefix)
        query = query
            .orderBy(searchField)
            .startAt([searchTerm])
            .endAt(['$searchTerm\uf8ff']);
      } else {
        // الحالة الافتراضية: الترتيب الزمني للأحدث
        query = query.orderBy('createdAt', descending: true);
      }

      // 5. تطبيق الـ Cursor والـ Limit للصفحات
      if (paginationParams.action == PaginationAction.next && paginationParams.lastDoc != null) {
        query = query.startAfterDocument(paginationParams.lastDoc!).limit(paginationParams.limit);
      } else if (paginationParams.action == PaginationAction.previous && paginationParams.firstDoc != null) {
        query = query.endBeforeDocument(paginationParams.firstDoc!).limitToLast(paginationParams.limit);
      } else {
        query = query.limit(paginationParams.limit);
      }

      final QuerySnapshot snapshot = await query.get();
      List<OrderModel> orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

      return {
        'orders': orders,
        'firstDoc': snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
        'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        'hasNextPage': snapshot.docs.length == paginationParams.limit,
      };
    } catch (e) {
      debugPrint('🔥 خطأ فايربيز في الطلبات: $e');

      throw Exception('فشل جلب الطلبات: $e');
    }
  }


  @override
  Stream<List<OrderStatusModel>> getOrderStatuses() {
    return _firestore
        .collection('orderStatuses')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => OrderStatusModel.fromFirestore(doc))
        .toList());
  }

  @override
  Stream<List<CancelReasonModel>> getCancelReasons() {
    return _firestore
        .collection('cancelReasons')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CancelReasonModel.fromFirestore(doc))
        .toList());
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String statusId,
    String? notes,
    String? cancelReason,
  }) async {
    final Map<String, dynamic> updateData = {
      'statusId': statusId,
    };

    if (notes != null) updateData['notes'] = notes;
    if (cancelReason != null) updateData['cancelReason'] = cancelReason;

    await _firestore.collection('orders').doc(orderId).update(updateData);
  }

  @override
  Future<void> addCancelReason(CancelReasonModel reason) async {
    await _firestore
        .collection('cancelReasons')
        .doc(reason.reasonId)
        .set(reason.toFirestore());
  }

  @override
  Future<void> toggleCancelReasonStatus({
    required String reasonId,
    required bool isActive,
  }) async {
    await _firestore
        .collection('cancelReasons')
        .doc(reasonId)
        .update({'isActive': isActive});
  }

  @override
  Future<void> toggleOrderStatusDetails({
    required String statusId,
    required bool isActive,
  }) async {
    await _firestore
        .collection('orderStatuses')
        .doc(statusId)
        .update({'isActive': isActive});
  }

  @override
  Future<void> updateOrderStatusDetails({
    required String statusId,
    required String name,
    String? description,
    required String colorHex,
  }) async {
    final Map<String, dynamic> updateData = {
      'name': name,
      'nameAr': name,
      'colorHex': colorHex,
    };

    if (description != null) {
      updateData['description'] = description;
    }

    await _firestore.collection('orderStatuses').doc(statusId).update(updateData);
  }

  @override
  Future<void> addOrderStatus(OrderStatusModel status) async {
    await _firestore
        .collection('orderStatuses')
        .doc(status.statusId)
        .set(status.toFirestore());
  }

  @override
  Stream<List<OrderModel>> getRecentProcessingOrdersStream({int limit = 5}) {
    return _firestore
        .collection('orders')
        .where('statusId', isEqualTo: 'processing')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }
}