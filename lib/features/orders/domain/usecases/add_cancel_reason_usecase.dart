import '../../../../core/errors/failure.dart';
import '../repositories/orders_repository.dart';
import '../../data/models/cancel_reason_model.dart';

import 'package:dartz/dartz.dart';


class AddCancelReasonUseCase {
  final OrdersRepository _repository;

  AddCancelReasonUseCase(this._repository);

  Future<Either<Failure, void>> call(CancelReasonModel reason) {
    return _repository.addCancelReason(reason);
  }
}