import '../../data/models/app_settings_model.dart';

abstract class AppSettingsRepository {
  Stream<AppSettingsModel> getAppSettings();
  Future<void> updateAppSettings(AppSettingsModel settings);
}
