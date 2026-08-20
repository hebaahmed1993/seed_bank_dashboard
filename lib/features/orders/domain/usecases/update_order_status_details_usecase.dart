import '../../../../core/errors/failure.dart';
import '../repositories/orders_repository.dart';

import 'package:dartz/dartz.dart';


class UpdateOrderStatusDetailsUseCase {
  final OrdersRepository _repository;

  UpdateOrderStatusDetailsUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String statusId,
    required String name,
    String? description,
    required String colorHex,
  }) {
    return _repository.updateOrderStatusDetails(
      statusId: statusId,
      name: name,
      description: description,
      colorHex: colorHex,
    );
  }
}
