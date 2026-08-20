import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/products_repository.dart';

class DeleteProductUseCase {
  final ProductsRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<Either<Failure, void>> call(String id, String categoryId) async {
    return await _repository.deleteProduct(id, categoryId);
  }
}
