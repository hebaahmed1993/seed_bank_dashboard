// features/locations/presentation/providers/locations_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/locations_remote_data_source.dart';
import '../../data/models/city_model.dart';
import '../../data/models/region_model.dart';
import '../../data/repositories/locations_repository_impl.dart';
import '../../domain/repositories/locations_repository.dart';

// UseCases المدن
import '../../domain/usecases/add_city_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/update_city_status_usecase.dart';
import '../../domain/usecases/update_city_usecase.dart';

// UseCases المناطق
import '../../domain/usecases/add_region_usecase.dart';
import '../../domain/usecases/get_regions_stream_usecase.dart';
import '../../domain/usecases/update_region_details_usecase.dart';
import '../../domain/usecases/update_region_status_usecase.dart';

import 'locations_state.dart';

// ==========================================
// 1. المزودات المركزية (Core Providers)
// ==========================================
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final locationsRemoteDataSourceProvider = Provider<LocationsRemoteDataSource>((ref) {
  return LocationsRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return LocationsRepositoryImpl(ref.watch(locationsRemoteDataSourceProvider));
});

// ==========================================
// 2. Providers الخاصة بالـ UseCases (مدن + مناطق)
// ==========================================
// -- المدن --
final getCitiesUseCaseProvider = Provider<GetCitiesUseCase>((ref) => GetCitiesUseCase(ref.watch(locationsRepositoryProvider)));
final updateCityStatusUseCaseProvider = Provider<UpdateCityStatusUseCase>((ref) => UpdateCityStatusUseCase(ref.watch(locationsRepositoryProvider)));
final addCityUseCaseProvider = Provider<AddCityUseCase>((ref) => AddCityUseCase(ref.watch(locationsRepositoryProvider)));
final updateCityUseCaseProvider = Provider<UpdateCityUseCase>((ref) => UpdateCityUseCase(ref.watch(locationsRepositoryProvider)));

// -- المناطق --
final getRegionsStreamUseCaseProvider = Provider<GetRegionsStreamUseCase>((ref) => GetRegionsStreamUseCase(ref.watch(locationsRepositoryProvider)));
final addRegionUseCaseProvider = Provider<AddRegionUseCase>((ref) => AddRegionUseCase(ref.watch(locationsRepositoryProvider)));
final updateRegionStatusUseCaseProvider = Provider<UpdateRegionStatusUseCase>((ref) => UpdateRegionStatusUseCase(ref.watch(locationsRepositoryProvider)));
final updateRegionDetailsUseCaseProvider = Provider<UpdateRegionDetailsUseCase>((ref) => UpdateRegionDetailsUseCase(ref.watch(locationsRepositoryProvider)));

// ==========================================
// 3. Stream Providers (جلب البيانات اللحظية)
// ==========================================
// بث المدن
final citiesStreamProvider = StreamProvider<List<CityModel>>((ref) {
  return ref.watch(getCitiesUseCaseProvider).call();
});

// بث المناطق (مع دمج اسم المدينة)
final regionsStreamProvider = StreamProvider<List<RegionModel>>((ref) {
  final getRegionsStream = ref.watch(getRegionsStreamUseCaseProvider);
  final citiesAsync = ref.watch(citiesStreamProvider);

  return getRegionsStream().map((regionsList) {
    final citiesList = citiesAsync.value ?? [];

    return regionsList.map((region) {
      final matchingCities = citiesList.where((c) => c.cityId == region.cityId);
      final cityName = matchingCities.isNotEmpty ? matchingCities.first.name : region.cityId;
      return region.copyWith(cityName: cityName);
    }).toList();
  });
});

// ==========================================
// 4. Locations Notifier (المتحكم الشامل)
// ==========================================
class LocationsNotifier extends StateNotifier<LocationsState> {
  // UseCases المدن
  final AddCityUseCase _addCityUseCase;
  final UpdateCityStatusUseCase _updateCityStatusUseCase;
  final UpdateCityUseCase _updateCityUseCase;

  // UseCases المناطق
  final AddRegionUseCase _addRegionUseCase;
  final UpdateRegionStatusUseCase _updateRegionStatusUseCase;
  final UpdateRegionDetailsUseCase _updateRegionDetailsUseCase;

  LocationsNotifier({
    required AddCityUseCase addCityUseCase,
    required UpdateCityStatusUseCase updateCityStatusUseCase,
    required UpdateCityUseCase updateCityUseCase,
    required AddRegionUseCase addRegionUseCase,
    required UpdateRegionStatusUseCase updateRegionStatusUseCase,
    required UpdateRegionDetailsUseCase updateRegionDetailsUseCase,
  })  : _addCityUseCase = addCityUseCase,
        _updateCityStatusUseCase = updateCityStatusUseCase,
        _updateCityUseCase = updateCityUseCase,
        _addRegionUseCase = addRegionUseCase,
        _updateRegionStatusUseCase = updateRegionStatusUseCase,
        _updateRegionDetailsUseCase = updateRegionDetailsUseCase,
        super(LocationsState());

  // -------------------------
  // دوال المدن
  // -------------------------
  Future<void> addNewCity(CityModel city) async {
    state = state.copyWith(addCityStatus: RequestStatus.loading, errorMessage: null);

    // 🎯 استخدام الـ UseCase المحقون مباشرة بدون _ref
    final result = await _addCityUseCase.call(city);

    result.fold(
          (failure) => state = state.copyWith(
        addCityStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(addCityStatus: RequestStatus.success),
    );
  }

  Future<void> updateCity({required String cityId, required String newName}) async {
    state = state.copyWith(updateCityStatus: RequestStatus.loading, errorMessage: null);

    // 🎯 تم إضافة أسماء المتغيرات (cityId: و newName:)
    final result = await _updateCityUseCase.call(cityId: cityId, newName: newName);

    result.fold(
          (failure) => state = state.copyWith(
        updateCityStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateCityStatus: RequestStatus.success),
    );
  }

  Future<void> toggleCityStatus({required String cityId, required bool isActive}) async {
    state = state.copyWith(updateCityStatus: RequestStatus.loading, errorMessage: null);

    // 🎯 إزالة try-catch واستخدام fold
    final result = await _updateCityStatusUseCase.call(cityId: cityId, isActive: isActive);

    result.fold(
          (failure) => state = state.copyWith(
        updateCityStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateCityStatus: RequestStatus.success),
    );
  }

  // -------------------------
  // دوال المناطق
  // -------------------------
  Future<void> addRegion(RegionModel region) async {
    state = state.copyWith(addRegionStatus: RequestStatus.loading, errorMessage: null);

    final result = await _addRegionUseCase.call(region);

    result.fold(
          (failure) => state = state.copyWith(
        addRegionStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(addRegionStatus: RequestStatus.success),
    );
  }

  Future<void> toggleRegionStatus({required String regionId, required bool isAvailable}) async {
    state = state.copyWith(updateRegionStatus: RequestStatus.loading, errorMessage: null);

    final result = await _updateRegionStatusUseCase.call(regionId: regionId, isAvailable: isAvailable);

    result.fold(
          (failure) => state = state.copyWith(
        updateRegionStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateRegionStatus: RequestStatus.success),
    );
  }

  Future<void> updateRegionDetails({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  }) async {
    state = state.copyWith(updateRegionStatus: RequestStatus.loading, errorMessage: null);

    final result = await _updateRegionDetailsUseCase.call(
      regionId: regionId,
      name: name,
      baseFee: baseFee,
      estimatedDays: estimatedDays,
    );

    result.fold(
          (failure) => state = state.copyWith(
        updateRegionStatus: RequestStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(updateRegionStatus: RequestStatus.success),
    );
  }
}

// ==========================================
// 5. الـ Provider الرئيسي للواجهة
// ==========================================
final locationsNotifierProvider = StateNotifierProvider<LocationsNotifier, LocationsState>((ref) {
  return LocationsNotifier(
    addCityUseCase: ref.watch(addCityUseCaseProvider),
    updateCityStatusUseCase: ref.watch(updateCityStatusUseCaseProvider),
    updateCityUseCase: ref.watch(updateCityUseCaseProvider),
    addRegionUseCase: ref.watch(addRegionUseCaseProvider),
    updateRegionStatusUseCase: ref.watch(updateRegionStatusUseCaseProvider),
    updateRegionDetailsUseCase: ref.watch(updateRegionDetailsUseCaseProvider),
  );
});