import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/models/product_model.dart';

abstract class ProductsRepository {
  Future<Either<Failure, Map<String, dynamic>>> getProductsPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? categoryId,
  });
  Future<Either<Failure, void>> addProduct(ProductModel product);
  Future<Either<Failure, void>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct(String id, String categoryId);
  Future<Either<Failure, void>> toggleProductStatus(String productId, bool isActive);
}