import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/datasources/statistics_remote_data_source.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/get_statistics_usecase.dart';
import 'statistics_state.dart';

// ==========================================
// 1. Data Source & Repository Providers
// ==========================================
final statisticsRemoteDataSourceProvider =
    Provider<StatisticsRemoteDataSource>((ref) {
  return StatisticsRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepositoryImpl(ref.watch(statisticsRemoteDataSourceProvider));
});

// ==========================================
// 2. Use Case Provider
// ==========================================
final getStatisticsUseCaseProvider = Provider<GetStatisticsUseCase>((ref) {
  return GetStatisticsUseCase(ref.watch(statisticsRepositoryProvider));
});

// ==========================================
// 3. State Notifier (Riverpod Clean Architecture 🧹)
// ==========================================
class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final GetStatisticsUseCase _getStatisticsUseCase;

  StatisticsNotifier(this._getStatisticsUseCase)
      : super(StatisticsState()) {
    fetchStatistics();
  }

  /// Fetches statistics using Dartz functional error handling.
  /// Uses `.fold()` without try-catch blocks.
  Future<void> fetchStatistics() async {
    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
    );

    final result = await _getStatisticsUseCase.call();

    result.fold(
          (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error, // 🎯 توحيد الاسم ليطابق الـ UI
          errorMessage: failure.message,
        );
      },
          (statisticsModel) {
        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          statistics: statisticsModel,
          errorMessage: null,
        );
      },
    );
  }
}

// ==========================================
// 4. StateNotifierProvider Export
// ==========================================
final statisticsNotifierProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  return StatisticsNotifier(ref.watch(getStatisticsUseCaseProvider));
});
