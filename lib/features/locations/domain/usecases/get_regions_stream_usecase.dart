import '../repositories/locations_repository.dart';
import '../../data/models/region_model.dart';

class GetRegionsStreamUseCase {
  final LocationsRepository _repository;

  GetRegionsStreamUseCase(this._repository);

  Stream<List<RegionModel>> call() {
    return _repository.getRegionsStream();
  }
}