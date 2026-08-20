import '../../../../core/enums/request_status.dart';

class CategoriesState {
  final RequestStatus fetchStatus;
  final RequestStatus addCategoryStatus;
  final RequestStatus updateCategoryStatus;
  final RequestStatus deleteCategoryStatus;
  final String? errorMessage;

  const CategoriesState({
    this.fetchStatus = RequestStatus.initial,
    this.addCategoryStatus = RequestStatus.initial,
    this.updateCategoryStatus = RequestStatus.initial,
    this.deleteCategoryStatus = RequestStatus.initial,
    this.errorMessage,
  });

  CategoriesState copyWith({
    RequestStatus? fetchStatus,
    RequestStatus? addCategoryStatus,
    RequestStatus? updateCategoryStatus,
    RequestStatus? deleteCategoryStatus,
    String? errorMessage,
  }) {
    return CategoriesState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      addCategoryStatus: addCategoryStatus ?? this.addCategoryStatus,
      updateCategoryStatus: updateCategoryStatus ?? this.updateCategoryStatus,
      deleteCategoryStatus: deleteCategoryStatus ?? this.deleteCategoryStatus,
      errorMessage: errorMessage,
    );
  }
}