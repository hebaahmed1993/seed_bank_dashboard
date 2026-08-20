import '../../../../core/enums/request_status.dart';

class AppSettingsState {
  final RequestStatus updateAppSettingsStatus;
  final String? errorMessage;

  const AppSettingsState({
    this.updateAppSettingsStatus = RequestStatus.initial,
    this.errorMessage,
  });

  AppSettingsState copyWith({
    RequestStatus? updateAppSettingsStatus,
    String? errorMessage,
  }) {
    return AppSettingsState(
      updateAppSettingsStatus:
          updateAppSettingsStatus ?? this.updateAppSettingsStatus,
      errorMessage: errorMessage,
    );
  }
}
