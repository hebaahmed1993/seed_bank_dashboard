import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/staff_model.dart';
import '../repositories/staff_repository.dart';

class AddStaffUseCase {
  final StaffRepository _repository;
  AddStaffUseCase(this._repository);

  Future<Either<Failure, void>> call(StaffModel staff) async {
    return await _repository.addStaff(staff);
  }
}