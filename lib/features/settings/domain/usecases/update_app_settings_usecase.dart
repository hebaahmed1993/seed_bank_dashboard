import '../../data/models/app_settings_model.dart';
import '../repositories/app_settings_repository.dart';

class UpdateAppSettingsUseCase {
  final AppSettingsRepository _repository;

  UpdateAppSettingsUseCase(this._repository);

  Future<void> call(AppSettingsModel settings) {
    return _repository.updateAppSettings(settings);
  }
}
