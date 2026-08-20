import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/models/supplier_model.dart';


abstract class SuppliersRepository {
  Future<Either<Failure, Map<String, dynamic>>> getSuppliersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    bool? isActive,
  });

  Future<Either<Failure, void>> addSupplier(SupplierModel supplier);
  Future<Either<Failure, void>> updateSupplier(SupplierModel supplier);
}