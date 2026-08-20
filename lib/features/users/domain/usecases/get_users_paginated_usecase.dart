import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/enums/status_filter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/pagination_params.dart';
import '../repositories/users_repository.dart';

class GetUsersPaginatedUseCase {
  final UsersRepository _repository;
  GetUsersPaginatedUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required PaginationParams paginationParams,
    String? searchQuery,
    String? cityId,
    StatusFilter? statusFilter,
  }) {
    return _repository.getUsersPaginated(
      paginationParams: paginationParams,
      searchQuery: searchQuery,
      cityId: cityId,
      statusFilter: statusFilter,
    );
  }
}