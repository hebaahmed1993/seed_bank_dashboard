import '../../domain/repositories/app_settings_repository.dart';
import '../datasources/app_settings_remote_data_source.dart';
import '../models/app_settings_model.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsRemoteDataSource _remoteDataSource;

  AppSettingsRepositoryImpl(this._remoteDataSource);

  @override
  Stream<AppSettingsModel> getAppSettings() {
    return _remoteDataSource.getAppSettingsStream();
  }

  @override
  Future<void> updateAppSettings(AppSettingsModel settings) {
    return _remoteDataSource.updateAppSettings(settings);
  }
}
