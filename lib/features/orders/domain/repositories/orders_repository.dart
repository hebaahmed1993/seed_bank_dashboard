import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_status_model.dart';
import '../../data/models/cancel_reason_model.dart';

abstract class OrdersRepository {
  // 🎯 دالة الجلب بالـ Pagination مع الفلاتر
  Future<Either<Failure, Map<String, dynamic>>> getOrdersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? statusFilter,
    String? cityFilter,
    DateTime? startDate,
    DateTime? endDate,
  });

  // 🎯 الجداول الصغيرة و الـ Dashboard تستخدم Stream
  Stream<List<OrderStatusModel>> getOrderStatuses();
  Stream<List<CancelReasonModel>> getCancelReasons();
  Stream<List<OrderModel>> getRecentProcessingOrdersStream({int limit = 5});

  // باقي دوال التعديل والإضافة
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String statusId,
    String? notes,
    String? cancelReason,
  });
  Future<Either<Failure, void>> addCancelReason(CancelReasonModel reason);
  Future<Either<Failure, void>> toggleCancelReasonStatus({required String reasonId, required bool isActive});
  Future<Either<Failure, void>> toggleOrderStatusDetails({required String statusId, required bool isActive});
  Future<Either<Failure, void>> updateOrderStatusDetails({
    required String statusId, required String name, String? description, required String colorHex,
  });
  Future<Either<Failure, void>> addOrderStatus(OrderStatusModel status);
}