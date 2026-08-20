import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_settings_model.dart';

abstract class AppSettingsRemoteDataSource {
  Stream<AppSettingsModel> getAppSettingsStream();
  Future<void> updateAppSettings(AppSettingsModel settings);
}

class AppSettingsRemoteDataSourceImpl implements AppSettingsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AppSettingsRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('appSettings');

  @override
  Stream<AppSettingsModel> getAppSettingsStream() {
    return _collection.limit(1).snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return AppSettingsModel.empty();
      }

      final doc = snapshot.docs.first;
      return AppSettingsModel.fromFirestore(doc.data(), doc.id);
    });
  }

  @override
  Future<void> updateAppSettings(AppSettingsModel settings) async {
    final snapshot = await _collection.limit(1).get();

    if (snapshot.docs.isEmpty) {
      await _collection.doc('main').set(settings.toFirestore());
      return;
    }

    await snapshot.docs.first.reference.update(settings.toFirestore());
  }
}
