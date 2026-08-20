import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/locations_repository.dart';

class UpdateCityUseCase {
  final LocationsRepository repository;

  UpdateCityUseCase(this.repository);

  Future<Either<Failure, void>> call({required String cityId, required String newName}) async {
    return await repository.updateCity(cityId: cityId, newName: newName);
  }
}