import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/locations_repository.dart';
import '../datasources/locations_remote_data_source.dart';
import '../models/city_model.dart';
import '../models/region_model.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDataSource _remoteDataSource;

  LocationsRepositoryImpl(this._remoteDataSource);

  // ==========================================
  //               دوال المدن
  // ==========================================

  @override
  Stream<List<CityModel>> getCities() {
    return _remoteDataSource.getCities();
  }

  @override
  Future<Either<Failure, void>> updateCityStatus({required String cityId, required bool isActive}) async {
    try {
      await _remoteDataSource.updateCityStatus(cityId: cityId, isActive: isActive);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCity(CityModel city) async {
    try {
      await _remoteDataSource.addCity(city);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCity({required String cityId, required String newName}) async {
    try {
      await _remoteDataSource.updateCity(cityId: cityId, newName: newName);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ==========================================
  //          دوال المناطق والتوصيل
  // ==========================================

  @override
  Stream<List<RegionModel>> getRegionsStream() {
    return _remoteDataSource.getRegionsStream();
  }

  @override
  Future<Either<Failure, void>> addRegion(RegionModel region) async {
    try {
      await _remoteDataSource.addRegion(region);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRegionStatus({required String regionId, required bool isAvailable}) async {
    try {
      await _remoteDataSource.updateRegionStatus(regionId: regionId, isAvailable: isAvailable);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRegionDetails({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  }) async {
    try {
      await _remoteDataSource.updateRegionDetails(
        regionId: regionId,
        name: name,
        baseFee: baseFee,
        estimatedDays: estimatedDays,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}