import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/product_model.dart';
import '../repositories/products_repository.dart';

class UpdateProductUseCase {
  final ProductsRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Either<Failure, void>> call(ProductModel product) async {
    return await _repository.updateProduct(product);
  }
}