import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/region_model.dart';
import '../repositories/locations_repository.dart';

class AddRegionUseCase {
  final LocationsRepository _repository;

  AddRegionUseCase(this._repository);

  Future<Either<Failure, void>> call(RegionModel region) async {
    return await _repository.addRegion(region);
  }
}