import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../data/models/order_model.dart';

class OrdersState {
  final RequestStatus fetchOrdersStatus;
  final PaginationModel<OrderModel> ordersPagination; // 🎯 استخدام الكلاس الموحد

  final RequestStatus updateOrderStatusStatus;
  final RequestStatus addCancelReasonStatus;
  final RequestStatus toggleCancelReasonStatus;
  final RequestStatus toggleOrderStatusDetailsStatus;
  final RequestStatus updateOrderStatusDetailsStatus;
  final RequestStatus addOrderStatusStatus;
  final String? errorMessage;

  OrdersState({
    this.fetchOrdersStatus = RequestStatus.initial,
    PaginationModel<OrderModel>? ordersPagination,
    this.updateOrderStatusStatus = RequestStatus.initial,
    this.addCancelReasonStatus = RequestStatus.initial,
    this.toggleCancelReasonStatus = RequestStatus.initial,
    this.toggleOrderStatusDetailsStatus = RequestStatus.initial,
    this.updateOrderStatusDetailsStatus = RequestStatus.initial,
    this.addOrderStatusStatus = RequestStatus.initial,
    this.errorMessage,
  }) : ordersPagination = ordersPagination ?? PaginationModel<OrderModel>();

  OrdersState copyWith({
    RequestStatus? fetchOrdersStatus,
    PaginationModel<OrderModel>? ordersPagination,
    RequestStatus? updateOrderStatusStatus,
    RequestStatus? addCancelReasonStatus,
    RequestStatus? toggleCancelReasonStatus,
    RequestStatus? toggleOrderStatusDetailsStatus,
    RequestStatus? updateOrderStatusDetailsStatus,
    RequestStatus? addOrderStatusStatus,
    String? errorMessage,
  }) {
    return OrdersState(
      fetchOrdersStatus: fetchOrdersStatus ?? this.fetchOrdersStatus,
      ordersPagination: ordersPagination ?? this.ordersPagination,
      updateOrderStatusStatus: updateOrderStatusStatus ?? this.updateOrderStatusStatus,
      addCancelReasonStatus: addCancelReasonStatus ?? this.addCancelReasonStatus,
      toggleCancelReasonStatus: toggleCancelReasonStatus ?? this.toggleCancelReasonStatus,
      toggleOrderStatusDetailsStatus: toggleOrderStatusDetailsStatus ?? this.toggleOrderStatusDetailsStatus,
      updateOrderStatusDetailsStatus: updateOrderStatusDetailsStatus ?? this.updateOrderStatusDetailsStatus,
      addOrderStatusStatus: addOrderStatusStatus ?? this.addOrderStatusStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}