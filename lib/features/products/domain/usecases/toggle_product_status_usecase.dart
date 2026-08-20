import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/products_repository.dart';

class ToggleProductStatusUseCase {
  final ProductsRepository _repository;

  ToggleProductStatusUseCase(this._repository);

  // 🎯 استخدام call كمعيار قياسي
  Future<Either<Failure, void>> call(String productId, bool isActive) async {
    return await _repository.toggleProductStatus(productId, isActive);
  }
}