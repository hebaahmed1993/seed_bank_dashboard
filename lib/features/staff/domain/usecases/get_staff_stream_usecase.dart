import '../../data/models/staff_model.dart';
import '../repositories/staff_repository.dart';

class GetStaffStreamUseCase {
  final StaffRepository _repository;
  GetStaffStreamUseCase(this._repository);

  Stream<List<StaffModel>> call() {
    return _repository.getStaffStream();
  }
}