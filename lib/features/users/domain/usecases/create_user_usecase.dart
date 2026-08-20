import '../repositories/users_repository.dart';
import '../../data/models/user_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';



class CreateUserUseCase {
  final UsersRepository _repository;
  CreateUserUseCase(this._repository);

  Future<Either<Failure, void>> execute({required UserModel user}) async {
    return await _repository.createUser(user: user);
  }
}