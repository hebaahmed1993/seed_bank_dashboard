import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/city_model.dart';
import '../models/region_model.dart';

abstract class LocationsRemoteDataSource {
  // --- دوال المدن ---
  Stream<List<CityModel>> getCities();
  Future<void> updateCityStatus({required String cityId, required bool isActive});
  Future<void> addCity(CityModel city);
  Future<void> updateCity({required String cityId, required String newName});

  // --- دوال المناطق والتوصيل ---
  Stream<List<RegionModel>> getRegionsStream();
  Future<void> addRegion(RegionModel region);
  Future<void> updateRegionStatus({required String regionId, required bool isAvailable});
  Future<void> updateRegionDetails({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  });
}

class LocationsRemoteDataSourceImpl implements LocationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  LocationsRemoteDataSourceImpl(this._firestore);

  // ==========================================
  //               دوال المدن
  // ==========================================

  @override
  Stream<List<CityModel>> getCities() {
    return _firestore.collection('cities').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CityModel.fromFirestore(doc.data())).toList();
    });
  }

  @override
  Future<void> updateCityStatus({required String cityId, required bool isActive}) async {
    await _firestore.collection('cities').doc(cityId).update({
      'isActive': isActive,
    });
  }

  @override
  Future<void> addCity(CityModel city) async {
    final docRef = _firestore.collection('cities').doc();
    final updatedCity = CityModel(
      cityId: docRef.id,
      name: city.name,
      isActive: city.isActive,
    );
    await docRef.set(updatedCity.toFirestore());
  }

  @override
  Future<void> updateCity({required String cityId, required String newName}) async {
    await _firestore.collection('cities').doc(cityId).update({
      'name': newName,
    });
  }

  // ==========================================
  //          دوال المناطق والتوصيل
  // ==========================================

  @override
  Stream<List<RegionModel>> getRegionsStream() {
    return _firestore.collection('regions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RegionModel.fromFirestore(doc.data())).toList();
    });
  }

  @override
  Future<void> addRegion(RegionModel region) async {
    // توليد مستند جديد بمعرف عشوائي تلقائياً من Firestore
    final docRef = _firestore.collection('regions').doc();

    final updatedRegion = RegionModel(
      regionId: docRef.id,
      cityId: region.cityId,
      name: region.name,
      baseFee: region.baseFee,
      estimatedDays: region.estimatedDays,
      isAvailable: region.isAvailable,
    );

    await docRef.set(updatedRegion.toFirestore());
  }

  @override
  Future<void> updateRegionStatus({required String regionId, required bool isAvailable}) async {
    await _firestore.collection('regions').doc(regionId).update({
      'isAvailable': isAvailable,
    });
  }

  @override
  Future<void> updateRegionDetails({
    required String regionId,
    required String name,
    required double baseFee,
    required String estimatedDays,
  }) async {
    await _firestore.collection('regions').doc(regionId).update({
      'name': name,
      'baseFee': baseFee,
      'estimatedDays': estimatedDays,
    });
  }
}