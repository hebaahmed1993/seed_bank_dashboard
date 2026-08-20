import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/locations_repository.dart';

class UpdateCityStatusUseCase {
  final LocationsRepository _repository;

  UpdateCityStatusUseCase(this._repository);

  Future<Either<Failure, void>> call({required String cityId, required bool isActive}) async {
    return await _repository.updateCityStatus(cityId: cityId, isActive: isActive);
  }
}