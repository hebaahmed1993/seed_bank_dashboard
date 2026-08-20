import '../../data/models/toggle_user_block_params_model.dart';
import '../repositories/users_repository.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';


class ToggleUserBlockStatusUseCase {
  final UsersRepository _repository;
  ToggleUserBlockStatusUseCase(this._repository);

  Future<Either<Failure, void>> execute(ToggleUserBlockParams params) async {
    if (params.userId.isEmpty)
      return Left(Failure('معرف المستخدم (UID) مطلوب لتعديل حالة الحظر.'));
    return await _repository.toggleUserBlockStatus(params);
  }
}
