// update_category_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/category_model.dart';
import '../repositories/categories_repository.dart';

class UpdateCategoryUseCase {
  final CategoriesRepository _repository;
  UpdateCategoryUseCase(this._repository);

  Future<Either<Failure, void>> call(CategoryModel category) => _repository.updateCategory(category);
}
