import '../../data/models/account_type_model.dart';
import '../repositories/staff_repository.dart';

class GetAccountTypesUseCase {
  final StaffRepository _repository;
  GetAccountTypesUseCase(this._repository);

  Stream<List<AccountTypeModel>> call() {
    return _repository.getAccountTypesStream();
  }
}