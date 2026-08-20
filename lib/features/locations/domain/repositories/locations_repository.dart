import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/city_model.dart';
import '../../data/models/region_model.dart';

abstract class LocationsRepository {
  // --- المدن ---
  Stream<List<CityModel>> getCities();
  Future<Either<Failure, void>> updateCityStatus({required String cityId, required bool isActive});
  Future<Either<Failure, void>> addCity(CityModel city);
  Future<Either<Failure, void>> updateCity({required String cityId, required String newName});

  // --- المناطق والتوصيل ---
  Stream<List<RegionModel>> getRegionsStream();
  Future<Either<Failure, void>> addRegion(RegionModel region);
  Future<Either<Failure, void>> updateRegionStatus({required String regionId, required bool isAvailable});
  Future<Either<Failure, void>> updateRegionDetails({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  });
}