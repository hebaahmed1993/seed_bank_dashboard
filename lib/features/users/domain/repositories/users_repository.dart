import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/enums/status_filter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/datasources/users_remote_data_source.dart';
import '../../data/models/toggle_user_block_params_model.dart';
import '../../data/models/user_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, void>> createUser({required UserModel user});
  Stream<List<UserModel>> getUsersStream();
  Future<Either<Failure, void>> updateUser({required UserModel user});
  Future<Either<Failure, void>> toggleUserBlockStatus(ToggleUserBlockParams params);
  Future<Either<Failure, Map<String, dynamic>>> getUsersPaginated({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? cityId,
    StatusFilter? statusFilter,
  });
}

