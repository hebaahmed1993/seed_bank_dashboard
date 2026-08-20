import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/pagination_action.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/datasources/orders_remote_data_source.dart';
import '../../data/models/cancel_reason_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_status_model.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/add_cancel_reason_usecase.dart';
import '../../domain/usecases/add_order_status_usecase.dart';
import '../../domain/usecases/get_cancel_reasons_usecase.dart';
import '../../domain/usecases/get_order_statuses_usecase.dart';
import '../../domain/usecases/get_orders_paginated_usecase.dart';
import '../../domain/usecases/get_recent_processing_orders_usecase.dart';
import '../../domain/usecases/toggle_cancel_reason_status_usecase.dart';
import '../../domain/usecases/toggle_order_status_details_usecase.dart';
import '../../domain/usecases/update_order_status_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'orders_state.dart';

// ====================================================================
// 1. Data Sources & Repositories Providers
// ====================================================================
final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  return OrdersRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl(ref.watch(ordersRemoteDataSourceProvider));
});

// ====================================================================
// 2. Use Cases Providers
// ====================================================================
final getOrdersPaginatedUseCaseProvider = Provider<GetOrdersPaginatedUseCase>((ref) {
  return GetOrdersPaginatedUseCase(ref.watch(ordersRepositoryProvider));
});

final updateOrderStatusUseCaseProvider = Provider<UpdateOrderStatusUseCase>((ref) {
  return UpdateOrderStatusUseCase(ref.watch(ordersRepositoryProvider));
});

final getOrderStatusesUseCaseProvider = Provider<GetOrderStatusesUseCase>((ref) {
  return GetOrderStatusesUseCase(ref.watch(ordersRepositoryProvider));
});

final getCancelReasonsUseCaseProvider = Provider<GetCancelReasonsUseCase>((ref) {
  return GetCancelReasonsUseCase(ref.watch(ordersRepositoryProvider));
});

final addCancelReasonUseCaseProvider = Provider<AddCancelReasonUseCase>((ref) {
  return AddCancelReasonUseCase(ref.watch(ordersRepositoryProvider));
});

final toggleCancelReasonStatusUseCaseProvider = Provider<ToggleCancelReasonStatusUseCase>((ref) {
  return ToggleCancelReasonStatusUseCase(ref.watch(ordersRepositoryProvider));
});

final toggleOrderStatusDetailsUseCaseProvider = Provider<ToggleOrderStatusDetailsUseCase>((ref) {
  return ToggleOrderStatusDetailsUseCase(ref.watch(ordersRepositoryProvider));
});

final updateOrderStatusDetailsUseCaseProvider = Provider<UpdateOrderStatusDetailsUseCase>((ref) {
  return UpdateOrderStatusDetailsUseCase(ref.watch(ordersRepositoryProvider));
});

final addOrderStatusUseCaseProvider = Provider<AddOrderStatusUseCase>((ref) {
  return AddOrderStatusUseCase(ref.watch(ordersRepositoryProvider));
});

final getRecentProcessingOrdersUseCaseProvider = Provider<GetRecentProcessingOrdersUseCase>((ref) {
  return GetRecentProcessingOrdersUseCase(ref.watch(ordersRepositoryProvider));
});

// ====================================================================
// 3. Stream Providers (للبيانات الصغيرة واللحظية)
// ====================================================================
final orderStatusesStreamProvider = StreamProvider<List<OrderStatusModel>>((ref) {
  return ref.watch(getOrderStatusesUseCaseProvider).call();
});

final cancelReasonsStreamProvider = StreamProvider<List<CancelReasonModel>>((ref) {
  return ref.watch(getCancelReasonsUseCaseProvider).call();
});

final recentProcessingOrdersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(getRecentProcessingOrdersUseCaseProvider).call();
});

// ====================================================================
// 4. State Providers (البحث والفلاتر)
// ====================================================================
final orderSearchQueryProvider = StateProvider<String>((ref) => '');
final orderStatusFilterProvider = StateProvider<String>((ref) => 'all');
final orderCityFilterProvider = StateProvider<String?>((ref) => null);
final orderStartDateProvider = StateProvider<DateTime?>((ref) => null);
final orderEndDateProvider = StateProvider<DateTime?>((ref) => null);

// ====================================================================
// 5. OrdersNotifier (إدارة حالة الطلبات والصفحات)
// ====================================================================
class OrdersNotifier extends StateNotifier<OrdersState> {
  final Ref _ref;
  final int limit = 10;

  OrdersNotifier(this._ref) : super(OrdersState()) {
    fetchPage(action: PaginationAction.refresh);
  }

  // =========================================================
  // عملية الجلب والفلترة (Pagination)
  // =========================================================
  Future<void> fetchPage({PaginationAction action = PaginationAction.refresh}) async {
    final pagination = state.ordersPagination;
    final bool isRefresh = action == PaginationAction.refresh;
    final int newPage = pagination.calculateNewPage(action);

    state = state.copyWith(
      fetchOrdersStatus: RequestStatus.loading,
      errorMessage: null,
      ordersPagination: isRefresh ? const PaginationModel<OrderModel>() : pagination,
    );

    final searchQuery = _ref.read(orderSearchQueryProvider);
    final statusFilter = _ref.read(orderStatusFilterProvider);
    final cityFilter = _ref.read(orderCityFilterProvider);
    final startDate = _ref.read(orderStartDateProvider);
    final endDate = _ref.read(orderEndDateProvider);

    final params = PaginationParams(
      limit: limit,
      action: action,
      firstDoc: isRefresh ? null : pagination.firstDoc,
      lastDoc: isRefresh ? null : pagination.lastDoc,
    );

    final result = await _ref.read(getOrdersPaginatedUseCaseProvider).execute(
      paginationParams: params,
      searchQuery: searchQuery,
      statusFilter: statusFilter,
      cityFilter: cityFilter,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          fetchOrdersStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        final List<OrderModel> newOrders = data['orders'] ?? [];

        state = state.copyWith(
          fetchOrdersStatus: RequestStatus.success,
          ordersPagination: pagination.copyWith(
            items: newOrders,
            firstDoc: data['firstDoc'],
            lastDoc: data['lastDoc'],
            currentPage: newPage,
            hasNextPage: data['hasNextPage'] ?? false,
            hasPreviousPage: newPage > 1,
          ),
        );
      },
    );
  }

  void goToNextPage() => fetchPage(action: PaginationAction.next);
  void goToPreviousPage() => fetchPage(action: PaginationAction.previous);
  void refreshWithFilters() => fetchPage(action: PaginationAction.refresh);

  // =========================================================
  // عمليات التعديل والإضافة والحالة
  // =========================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required String statusId,
    String? notes,
    String? cancelReason,
  }) async {
    state = state.copyWith(updateOrderStatusStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(updateOrderStatusUseCaseProvider).call(
      orderId: orderId, statusId: statusId, notes: notes, cancelReason: cancelReason,
    );
    result.fold(
          (failure) => state = state.copyWith(updateOrderStatusStatus: RequestStatus.error, errorMessage: failure.message),
          (_) {
        state = state.copyWith(updateOrderStatusStatus: RequestStatus.success);
        refreshWithFilters(); // تحديث الجدول بعد التغيير
      },
    );
  }

  Future<void> toggleCancelReasonStatus({required String reasonId, required bool isActive}) async {
    state = state.copyWith(toggleCancelReasonStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(toggleCancelReasonStatusUseCaseProvider).call(reasonId: reasonId, isActive: isActive);
    result.fold(
          (failure) => state = state.copyWith(toggleCancelReasonStatus: RequestStatus.error, errorMessage: failure.message),
          (_) => state = state.copyWith(toggleCancelReasonStatus: RequestStatus.success),
    );
  }

  Future<void> addCancelReason(CancelReasonModel reason) async {
    state = state.copyWith(addCancelReasonStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(addCancelReasonUseCaseProvider).call(reason);
    result.fold(
          (failure) => state = state.copyWith(addCancelReasonStatus: RequestStatus.error, errorMessage: failure.message),
          (_) => state = state.copyWith(addCancelReasonStatus: RequestStatus.success),
    );
  }

  Future<void> toggleOrderStatusDetails({required String statusId, required bool isActive}) async {
    state = state.copyWith(toggleOrderStatusDetailsStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(toggleOrderStatusDetailsUseCaseProvider).call(statusId: statusId, isActive: isActive);
    result.fold(
          (failure) => state = state.copyWith(toggleOrderStatusDetailsStatus: RequestStatus.error, errorMessage: failure.message),
          (_) => state = state.copyWith(toggleOrderStatusDetailsStatus: RequestStatus.success),
    );
  }

  Future<void> updateOrderStatusDetails(OrderStatusModel status) async {
    state = state.copyWith(
      updateOrderStatusDetailsStatus: RequestStatus.loading,
      errorMessage: null,
    );

    // 🎯 نقوم بتفكيك الكائن هنا وتمرير قيمه للـ UseCase
    final result = await _ref.read(updateOrderStatusDetailsUseCaseProvider).call(
      statusId: status.statusId,
      name: status.name,
      description: status.description,
      colorHex: status.colorHex,
    );

    result.fold(
          (failure) => state = state.copyWith(
        updateOrderStatusDetailsStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateOrderStatusDetailsStatus: RequestStatus.success),
    );
  }

  Future<void> addOrderStatus(OrderStatusModel status) async {
    state = state.copyWith(addOrderStatusStatus: RequestStatus.loading, errorMessage: null);
    final result = await _ref.read(addOrderStatusUseCaseProvider).call(status);
    result.fold(
          (failure) => state = state.copyWith(addOrderStatusStatus: RequestStatus.error, errorMessage: failure.message),
          (_) => state = state.copyWith(addOrderStatusStatus: RequestStatus.success),
    );
  }
}

// ====================================================================
// 6. Provider النهائي
// ====================================================================
final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  // لا نستخدم ref.watch هنا أبداً لضمان عدم تدمير الكلاس وفقدان أرقام الصفحات والـ Cursors
  return OrdersNotifier(ref);
});