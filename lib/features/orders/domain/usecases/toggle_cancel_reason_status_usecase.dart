import '../../../../core/errors/failure.dart';
import '../repositories/orders_repository.dart';

import 'package:dartz/dartz.dart';


class ToggleCancelReasonStatusUseCase {
  final OrdersRepository _repository;

  ToggleCancelReasonStatusUseCase(this._repository);

  Future<Either<Failure, void>> call({required String reasonId, required bool isActive}) {
    return _repository.toggleCancelReasonStatus(reasonId: reasonId, isActive: isActive);
  }
}