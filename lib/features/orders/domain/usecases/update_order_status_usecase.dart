import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase {
  final OrdersRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String orderId,
    required String statusId,
    String? notes,
    String? cancelReason,
  }) {
    return _repository.updateOrderStatus(
      orderId: orderId,
      statusId: statusId,
      notes: notes,
      cancelReason: cancelReason,
    );
  }
}