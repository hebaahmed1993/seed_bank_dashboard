import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:seed_bank_dashboard/core/params/pagination_params.dart';

import '../../../../core/enums/status_filter.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';
import '../models/toggle_user_block_params_model.dart';
import '../models/user_model.dart';
class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource _remoteDataSource;

  UsersRepositoryImpl(this._remoteDataSource);


  @override
  Future<Either<Failure, void>> createUser({required UserModel user}) async {
    try {
      await _remoteDataSource.createUser(userModel: user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<UserModel>> getUsersStream() {
    return _remoteDataSource.getUsersStream();
  }

  @override
  Future<Either<Failure, void>> updateUser({required UserModel user}) async {
    try {
      await _remoteDataSource.updateUser(userModel: user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleUserBlockStatus(ToggleUserBlockParams params) async {
    try {
      await _remoteDataSource.toggleUserBlockStatus(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUsersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? cityId,
    StatusFilter? statusFilter,
  }) async {
    try {
      final result = await _remoteDataSource.getUsersPaginated(
        paginationParams: paginationParams,
        searchQuery: searchQuery,
        cityId: cityId,
        statusFilter: statusFilter,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}