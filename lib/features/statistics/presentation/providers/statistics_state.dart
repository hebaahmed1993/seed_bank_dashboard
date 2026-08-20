import '../../../../core/enums/request_status.dart';
import '../../data/models/statistics_model.dart';

/// Immutable state class for the Statistics feature.
///
/// [fetchStatus]  — granular status for the fetch operation.
/// [statistics]   — the loaded data; defaults to [StatisticsModel.empty()].
/// [errorMessage] — populated only when [fetchStatus] == [RequestStatus.failure].
class StatisticsState {
  final RequestStatus fetchStatus;
  final StatisticsModel statistics;
  final String? errorMessage;

  StatisticsState({
    this.fetchStatus = RequestStatus.initial,
    StatisticsModel? statistics,
    this.errorMessage,
  }) : statistics = statistics ?? StatisticsModel.empty();

  StatisticsState copyWith({
    RequestStatus? fetchStatus,
    StatisticsModel? statistics,
    String? errorMessage,
  }) {
    return StatisticsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage,
    );
  }
}
