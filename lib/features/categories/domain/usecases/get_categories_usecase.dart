// get_categories_usecase.dart
import '../../data/models/category_model.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository _repository;
  GetCategoriesUseCase(this._repository);

  Stream<List<CategoryModel>> call() => _repository.getCategories();
}




