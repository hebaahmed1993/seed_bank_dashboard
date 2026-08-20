import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../repositories/orders_repository.dart';

class GetOrdersPaginatedUseCase {
  final OrdersRepository _repository;

  GetOrdersPaginatedUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? statusFilter,
    String? cityFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.getOrdersPaginated(
      paginationParams: paginationParams,
      searchQuery: searchQuery,
      statusFilter: statusFilter,
      cityFilter: cityFilter,
      startDate: startDate,
      endDate: endDate,
    );
  }
}