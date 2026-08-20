import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/staff_repository.dart';



class ToggleStaffBlockUseCase {
  final StaffRepository _repository;
  ToggleStaffBlockUseCase(this._repository);

  Future<Either<Failure, void>> call({required String staffId, required bool isBlocked}) async {
    return await _repository.toggleStaffBlock(staffId, isBlocked);
  }
}