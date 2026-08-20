import '../repositories/users_repository.dart';
import '../../data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';


class UpdateUserUseCase {
  final UsersRepository _repository;
  UpdateUserUseCase(this._repository);

  Future<Either<Failure, void>> execute({required UserModel user}) async {
    return await _repository.updateUser(user: user);
  }
}