import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/locations_repository.dart';

class UpdateRegionDetailsUseCase {
  final LocationsRepository _repository;

  UpdateRegionDetailsUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  }) async {
    return await _repository.updateRegionDetails(
      regionId: regionId,
      name: name,
      baseFee: baseFee,
      estimatedDays: estimatedDays,
    );
  }
}