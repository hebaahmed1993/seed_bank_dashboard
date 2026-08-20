import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/app_settings_remote_data_source.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/repositories/app_settings_repository_impl.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../../domain/usecases/get_app_settings_usecase.dart';
import '../../domain/usecases/update_app_settings_usecase.dart';
import 'app_settings_state.dart';

// --- Providers Setup ---
final appSettingsFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final appSettingsRemoteDataSourceProvider =
    Provider<AppSettingsRemoteDataSource>((ref) {
  return AppSettingsRemoteDataSourceImpl(
    ref.watch(appSettingsFirestoreProvider),
  );
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepositoryImpl(
    ref.watch(appSettingsRemoteDataSourceProvider),
  );
});

// Providers for UseCases
final getAppSettingsUseCaseProvider = Provider<GetAppSettingsUseCase>((ref) {
  return GetAppSettingsUseCase(ref.watch(appSettingsRepositoryProvider));
});

final updateAppSettingsUseCaseProvider =
    Provider<UpdateAppSettingsUseCase>((ref) {
  return UpdateAppSettingsUseCase(ref.watch(appSettingsRepositoryProvider));
});

// Stream Provider
final appSettingsStreamProvider = StreamProvider<AppSettingsModel>((ref) {
  return ref.watch(getAppSettingsUseCaseProvider).call();
});

// State Notifier Provider
final appSettingsNotifierProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>((ref) {
  return AppSettingsNotifier(ref.watch(updateAppSettingsUseCaseProvider));
});

// --- State Notifier Class ---
class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  final UpdateAppSettingsUseCase _updateAppSettingsUseCase;

  AppSettingsNotifier(this._updateAppSettingsUseCase)
      : super(const AppSettingsState());

  Future<bool> updateAppSettings(AppSettingsModel settings) async {
    state = state.copyWith(updateAppSettingsStatus: RequestStatus.loading);

    try {
      await _updateAppSettingsUseCase.call(settings);
      state = state.copyWith(updateAppSettingsStatus: RequestStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        updateAppSettingsStatus: RequestStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
