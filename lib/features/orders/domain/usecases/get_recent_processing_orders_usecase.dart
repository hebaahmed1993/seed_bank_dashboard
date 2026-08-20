import '../repositories/orders_repository.dart';
import '../../data/models/order_model.dart';

class GetRecentProcessingOrdersUseCase {
  final OrdersRepository _repository;

  GetRecentProcessingOrdersUseCase(this._repository);

  Stream<List<OrderModel>> call({int limit = 5}) {
    return _repository.getRecentProcessingOrdersStream(limit: limit);
  }
}
