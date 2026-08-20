import '../../../../core/errors/failure.dart';
import '../../data/models/order_status_model.dart';
import '../repositories/orders_repository.dart';

import 'package:dartz/dartz.dart';


class AddOrderStatusUseCase {
  final OrdersRepository _repository;

  AddOrderStatusUseCase(this._repository);

  Future<Either<Failure, void>> call(OrderStatusModel status) {
    return _repository.addOrderStatus(status);
  }
}