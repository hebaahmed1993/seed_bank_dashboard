import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/staff_repository.dart';

class UpdateStaffRoleUseCase {
  final StaffRepository _repository;
  UpdateStaffRoleUseCase(this._repository);

  Future<Either<Failure, void>> call({required String staffId, required String newRoleId}) async {
    return await _repository.updateStaffRole(staffId, newRoleId);
  }
}

