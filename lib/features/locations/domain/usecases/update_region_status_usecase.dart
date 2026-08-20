import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/locations_repository.dart';

class UpdateRegionStatusUseCase {
  final LocationsRepository _repository;

  UpdateRegionStatusUseCase(this._repository);

  Future<Either<Failure, void>> call({required String regionId, required bool isAvailable}) async {
    return await _repository.updateRegionStatus(regionId: regionId, isAvailable: isAvailable);
  }
}