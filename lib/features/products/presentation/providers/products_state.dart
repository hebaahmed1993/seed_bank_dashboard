import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../data/models/product_model.dart';

class ProductsState {
  final RequestStatus fetchStatus;
  final RequestStatus createStatus;
  final RequestStatus updateStatus;
  final RequestStatus deleteStatus;
  final String? errorMessage;
  final PaginationModel<ProductModel> pagination;

  const ProductsState({
    this.fetchStatus = RequestStatus.initial,
    this.createStatus = RequestStatus.initial,
    this.updateStatus = RequestStatus.initial,
    this.deleteStatus = RequestStatus.initial,
    this.errorMessage,
    this.pagination = const PaginationModel<ProductModel>(items: []),
  });

  ProductsState copyWith({
    RequestStatus? fetchStatus,
    RequestStatus? createStatus,
    RequestStatus? updateStatus,
    RequestStatus? deleteStatus,
    String? errorMessage,
    PaginationModel<ProductModel>? pagination,
  }) {
    return ProductsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      pagination: pagination ?? this.pagination,
    );
  }
}