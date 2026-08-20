import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../repositories/suppliers_repository.dart';

class GetSuppliersPaginatedUseCase {
  final SuppliersRepository _repository;

  GetSuppliersPaginatedUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required PaginationParams paginationParams,
    String? searchQuery,
    bool? isActive,
  }) async {
    return await _repository.getSuppliersPaginated(
      paginationParams: paginationParams,
      searchQuery: searchQuery,
      isActive: isActive,
    );
  }
}