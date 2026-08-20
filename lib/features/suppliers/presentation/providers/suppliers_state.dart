import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../data/models/supplier_model.dart';

class SuppliersState {
  final RequestStatus fetchStatus;
  final RequestStatus addStatus;
  final RequestStatus updateStatus;
  final String? errorMessage;
  final PaginationModel<SupplierModel> pagination;

  SuppliersState({
    this.fetchStatus = RequestStatus.initial,
    this.addStatus = RequestStatus.initial,
    this.updateStatus = RequestStatus.initial,
    this.errorMessage,
    PaginationModel<SupplierModel>? pagination,
  }) : pagination = pagination ?? const PaginationModel<SupplierModel>(items: []);

  SuppliersState copyWith({
    RequestStatus? fetchStatus,
    RequestStatus? addStatus,
    RequestStatus? updateStatus,
    String? errorMessage,
    PaginationModel<SupplierModel>? pagination,
  }) {
    return SuppliersState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      addStatus: addStatus ?? this.addStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      pagination: pagination ?? this.pagination,
    );
  }
}