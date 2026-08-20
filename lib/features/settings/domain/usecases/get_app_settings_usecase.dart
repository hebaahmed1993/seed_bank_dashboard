import '../../data/models/app_settings_model.dart';
import '../repositories/app_settings_repository.dart';

class GetAppSettingsUseCase {
  final AppSettingsRepository _repository;

  GetAppSettingsUseCase(this._repository);

  Stream<AppSettingsModel> call() {
    return _repository.getAppSettings();
  }
}
