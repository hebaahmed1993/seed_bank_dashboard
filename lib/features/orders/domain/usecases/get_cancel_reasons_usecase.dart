


import '../../data/models/cancel_reason_model.dart';
import '../repositories/orders_repository.dart';



class GetCancelReasonsUseCase {
  final OrdersRepository _repository;

  GetCancelReasonsUseCase(this._repository);

  Stream<List<CancelReasonModel>> call() {
    return _repository.getCancelReasons();
  }
}