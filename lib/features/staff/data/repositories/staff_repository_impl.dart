import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_data_source.dart';
import '../models/account_type_model.dart';
import '../models/staff_model.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource _remoteDataSource;

  StaffRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<StaffModel>> getStaffStream() {
    return _remoteDataSource.getStaffStream();
  }

  @override
  Stream<List<AccountTypeModel>> getAccountTypesStream() {
    return _remoteDataSource.getAccountTypesStream();
  }

  @override
  Future<Either<Failure, void>> addStaff(StaffModel staff) async {
    try {
      await _remoteDataSource.addStaff(staff);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStaffRole(String staffId, String newRoleId) async {
    try {
      await _remoteDataSource.updateStaffRole(staffId, newRoleId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleStaffBlock(String staffId, bool isBlocked) async {
    try {
      await _remoteDataSource.toggleStaffBlock(staffId, isBlocked);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}