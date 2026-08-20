import '../../data/models/city_model.dart';
import '../repositories/locations_repository.dart';

class GetCitiesUseCase {
  final LocationsRepository _repository;

  GetCitiesUseCase(this._repository);

  Stream<List<CityModel>> call() {
    return _repository.getCities();
  }
}