import '../../../../core/errors/failure.dart';
import '../repositories/orders_repository.dart';

import 'package:dartz/dartz.dart';


class ToggleOrderStatusDetailsUseCase {
  final OrdersRepository _repository;

  ToggleOrderStatusDetailsUseCase(this._repository);

  Future<Either<Failure, void>> call({required String statusId, required bool isActive}) {
    return _repository.toggleOrderStatusDetails(statusId: statusId, isActive: isActive);
  }
}