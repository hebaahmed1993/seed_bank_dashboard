import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/categories_remote_data_source.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/repositories/categories_repository.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import 'categories_state.dart';

// --- Providers Setup ---
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final categoriesRemoteDataSourceProvider = Provider<CategoriesRemoteDataSource>((ref) {
  return CategoriesRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepositoryImpl(ref.watch(categoriesRemoteDataSourceProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoriesRepositoryProvider));
});

final addCategoryUseCaseProvider = Provider<AddCategoryUseCase>((ref) {
  return AddCategoryUseCase(ref.watch(categoriesRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  return UpdateCategoryUseCase(ref.watch(categoriesRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  return DeleteCategoryUseCase(ref.watch(categoriesRepositoryProvider));
});

// Stream Provider
final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(getCategoriesUseCaseProvider).call();
});

// State Notifier Provider
final categoriesNotifierProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  return CategoriesNotifier(
    ref.watch(addCategoryUseCaseProvider),
    ref.watch(updateCategoryUseCaseProvider),
    ref.watch(deleteCategoryUseCaseProvider),
  );
});

// --- State Notifier Class ---
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoriesNotifier(
      this._addCategoryUseCase,
      this._updateCategoryUseCase,
      this._deleteCategoryUseCase,
      ) : super(const CategoriesState());

  Future<void> addCategory(CategoryModel category) async {
    state = state.copyWith(addCategoryStatus: RequestStatus.loading);
    final result = await _addCategoryUseCase(category);
    result.fold(
          (failure) => state = state.copyWith(
        addCategoryStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(addCategoryStatus: RequestStatus.success),
    );
  }

  Future<void> updateCategory(CategoryModel category) async {
    state = state.copyWith(updateCategoryStatus: RequestStatus.loading);
    final result = await _updateCategoryUseCase(category);
    result.fold(
          (failure) => state = state.copyWith(
        updateCategoryStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateCategoryStatus: RequestStatus.success),
    );
  }

  Future<void> deleteCategory(CategoryModel category) async {
    state = state.copyWith(deleteCategoryStatus: RequestStatus.loading);
    final result = await _deleteCategoryUseCase(category);
    result.fold(
          (failure) => state = state.copyWith(
        deleteCategoryStatus: RequestStatus.failure,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(deleteCategoryStatus: RequestStatus.success),
    );
  }

  void resetAddStatus() => state = state.copyWith(addCategoryStatus: RequestStatus.initial);
  void resetUpdateStatus() => state = state.copyWith(updateCategoryStatus: RequestStatus.initial);
  void resetDeleteStatus() => state = state.copyWith(deleteCategoryStatus: RequestStatus.initial);
}