import '../repositories/orders_repository.dart';
import '../../data/models/order_status_model.dart';

class GetOrderStatusesUseCase {
  final OrdersRepository _repository;

  GetOrderStatusesUseCase(this._repository);

  Stream<List<OrderStatusModel>> call() {
    return _repository.getOrderStatuses();
  }
}