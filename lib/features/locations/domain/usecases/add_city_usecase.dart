import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/city_model.dart';
import '../repositories/locations_repository.dart';

class AddCityUseCase {
  final LocationsRepository _repository;

  AddCityUseCase(this._repository);

  Future<Either<Failure, void>> call(CityModel city) async {
    return await _repository.addCity(city);
  }
}