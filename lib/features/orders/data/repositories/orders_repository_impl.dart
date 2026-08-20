import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';
import '../models/order_status_model.dart';
import '../models/cancel_reason_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrdersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? statusFilter,
    String? cityFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.getOrdersPaginated(
        paginationParams: paginationParams,
        searchQuery: searchQuery,
        statusFilter: statusFilter,
        cityFilter: cityFilter,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<OrderStatusModel>> getOrderStatuses() => _remoteDataSource.getOrderStatuses();

  @override
  Stream<List<CancelReasonModel>> getCancelReasons() => _remoteDataSource.getCancelReasons();

  @override
  Stream<List<OrderModel>> getRecentProcessingOrdersStream({int limit = 5}) =>
      _remoteDataSource.getRecentProcessingOrdersStream(limit: limit);

  // 🎯 اصطياد الأخطاء وتحويلها إلى Left(Failure)
  @override
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String statusId,
    String? notes,
    String? cancelReason,
  }) async {
    try {
      await _remoteDataSource.updateOrderStatus(
        orderId: orderId, statusId: statusId, notes: notes, cancelReason: cancelReason,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCancelReason(CancelReasonModel reason) async {
    try {
      await _remoteDataSource.addCancelReason(reason);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleCancelReasonStatus({required String reasonId, required bool isActive}) async {
    try {
      await _remoteDataSource.toggleCancelReasonStatus(reasonId: reasonId, isActive: isActive);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleOrderStatusDetails({required String statusId, required bool isActive}) async {
    try {
      await _remoteDataSource.toggleOrderStatusDetails(statusId: statusId, isActive: isActive);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatusDetails({
    required String statusId, required String name, String? description, required String colorHex,
  }) async {
    try {
      await _remoteDataSource.updateOrderStatusDetails(statusId: statusId, name: name, description: description, colorHex: colorHex);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addOrderStatus(OrderStatusModel status) async {
    try {
      await _remoteDataSource.addOrderStatus(status);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }


}