import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../domain/repositories/suppliers_repository.dart';
import '../datasources/suppliers_remote_data_source.dart';
import '../models/supplier_model.dart';

class SuppliersRepositoryImpl implements SuppliersRepository {
  final SuppliersRemoteDataSource _remoteDataSource;

  SuppliersRepositoryImpl(this._remoteDataSource);


  @override
  Future<Either<Failure, void>> addSupplier(SupplierModel supplier) async {
    try {
      await _remoteDataSource.addSupplier(supplier);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSupplier(SupplierModel supplier) async {
    try {
      await _remoteDataSource.updateSupplier(supplier);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSuppliersPaginated({required PaginationParams paginationParams,
    String? searchQuery,
    bool? isActive}) async {






      try {
        final result = await _remoteDataSource.getSuppliersPaginated(
          paginationParams: paginationParams,
          searchQuery: searchQuery,
          isActive: isActive,
        );
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
  }
}