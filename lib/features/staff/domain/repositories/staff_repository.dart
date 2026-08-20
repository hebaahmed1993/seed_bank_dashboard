import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/account_type_model.dart';
import '../../data/models/staff_model.dart';

abstract class StaffRepository {
  Stream<List<StaffModel>> getStaffStream();
  Stream<List<AccountTypeModel>> getAccountTypesStream();
  Future<Either<Failure, void>> addStaff(StaffModel staff);
  Future<Either<Failure, void>> updateStaffRole(String staffId, String newRoleId);
  Future<Either<Failure, void>> toggleStaffBlock(String staffId, bool isBlocked);
}