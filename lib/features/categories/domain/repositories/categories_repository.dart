import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/category_model.dart';

abstract class CategoriesRepository {
  Stream<List<CategoryModel>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryModel category);
  Future<Either<Failure, void>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> deleteCategory(CategoryModel category);
}