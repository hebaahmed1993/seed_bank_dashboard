import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepositoryImpl(this._remoteDataSource);
// 🎯 تطبيق الدالة الجديدة لاصطياد الأخطاء وإرجاع Either
  @override
  Future<Either<Failure, void>> toggleProductStatus(String productId, bool isActive) async {
    try {
      await _remoteDataSource.toggleProductStatus(productId, isActive);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, Map<String, dynamic>>> getProductsPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? categoryId,
  }) async {
    try {
      final result = await _remoteDataSource.getProductsPaginated(
        paginationParams: paginationParams,
        searchQuery: searchQuery,
        categoryId: categoryId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      await _remoteDataSource.addProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      await _remoteDataSource.updateProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id, String categoryId) async {
    try {
      await _remoteDataSource.deleteProduct(id, categoryId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
