import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/pagination_action.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/datasources/products_remote_data_source.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'products_state.dart';

// ==========================================
// 1. Filter & Search State Providers
// ==========================================
final productSearchQueryProvider = StateProvider<String>((ref) => '');
final productCategoryFilterProvider = StateProvider<String?>((ref) => null);

// ==========================================
// 2. Core Providers
// ==========================================
final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((ref) {
  return ProductsRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(ref.watch(productsRemoteDataSourceProvider));
});

// ==========================================
// 3. UseCases Providers
// ==========================================
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productsRepositoryProvider));
});

final addProductUseCaseProvider = Provider<AddProductUseCase>((ref) {
  return AddProductUseCase(ref.watch(productsRepositoryProvider));
});

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  return UpdateProductUseCase(ref.watch(productsRepositoryProvider));
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  return DeleteProductUseCase(ref.watch(productsRepositoryProvider));
});

// ==========================================
// 4. Notifier (Clean Architecture 🧹)
// ==========================================
class ProductsNotifier extends StateNotifier<ProductsState> {
  final Ref _ref;
  final int limit = 15;

  ProductsNotifier(this._ref) : super(const ProductsState()) {
    fetchPage(action: PaginationAction.refresh);
  }

  Future<void> fetchPage({PaginationAction action = PaginationAction.refresh}) async {
    final pagination = state.pagination;
    final bool isRefresh = action == PaginationAction.refresh;
    final int newPage = pagination.calculateNewPage(action);

    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
      pagination: isRefresh ? const PaginationModel<ProductModel>() : pagination,
    );

    final searchQuery = _ref.read(productSearchQueryProvider);
    final categoryId = _ref.read(productCategoryFilterProvider);

    final params = PaginationParams(
      limit: limit,
      action: action,
      firstDoc: isRefresh ? null : pagination.firstDoc,
      lastDoc: isRefresh ? null : pagination.lastDoc,
    );

    final result = await _ref.read(getProductsUseCaseProvider).call(
      paginationParams: params,
      searchQuery: searchQuery,
      categoryId: categoryId,
    );

    result.fold(
          (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (data) {
        final rawItems = data['items'] ?? data['products'] ?? [];
        final List<ProductModel> newProducts = List<ProductModel>.from(rawItems);

        // 🎯 الحل السحري هنا: حماية من "الصفحة الوهمية"
        // إذا ضغطنا "التالي" ولم نجد أي منتجات إضافية، نوقف الانتقال للصفحة الجديدة
        if (action == PaginationAction.next && newProducts.isEmpty) {
          state = state.copyWith(
            fetchStatus: RequestStatus.success, // نوقف التحميل
            pagination: pagination.copyWith(
              hasNextPage: false, // نخفي زر التالي نهائياً
            ),
          );
          return; // 🛑 نوقف التنفيذ هنا لكي لا تمسح المنتجات المعروضة
        }

        // في الوضع الطبيعي، نقوم بتحديث البيانات
        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          pagination: pagination.copyWith(
            items: newProducts,
            firstDoc: data['firstDoc'],
            lastDoc: data['lastDoc'],
            currentPage: newPage,
            hasNextPage: data['hasNextPage'] ?? false,
            hasPreviousPage: newPage > 1,
          ),
        );
      },
    );
  }

  void goToNextPage() => fetchPage(action: PaginationAction.next);
  void goToPreviousPage() => fetchPage(action: PaginationAction.previous);

  Future<void> addProduct(ProductModel product) async {
    state = state.copyWith(createStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(addProductUseCaseProvider).call(product);

    result.fold(
          (failure) => state = state.copyWith(
        createStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(createStatus: RequestStatus.success);
        fetchPage(action: PaginationAction.refresh);
      },
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    state = state.copyWith(updateStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(updateProductUseCaseProvider).call(product);

    result.fold(
          (failure) => state = state.copyWith(
        updateStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(updateStatus: RequestStatus.success);
        fetchPage(action: PaginationAction.refresh);
      },
    );
  }

  Future<void> deleteProduct(String id, String categoryId) async {
    state = state.copyWith(deleteStatus: RequestStatus.loading, errorMessage: null);

    final result = await _ref.read(deleteProductUseCaseProvider).call(id, categoryId);

    result.fold(
          (failure) => state = state.copyWith(
        deleteStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) {
        state = state.copyWith(deleteStatus: RequestStatus.success);
        fetchPage(action: PaginationAction.refresh);
      },
    );
  }
}

// ==========================================
// 5. Provider Export
// ==========================================
final productsNotifierProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref);
});