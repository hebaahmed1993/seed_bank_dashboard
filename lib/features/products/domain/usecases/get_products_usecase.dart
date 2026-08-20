import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? categoryId,
  }) async {
    return await _repository.getProductsPaginated(
      paginationParams: paginationParams,
      searchQuery: searchQuery,
      categoryId: categoryId,
    );
  }
}