import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/statistics_model.dart';

/// Domain-layer contract for statistics data access.
/// Returns `Either<Failure, StatisticsModel>` so callers never deal with exceptions.
abstract class StatisticsRepository {
  Future<Either<Failure, StatisticsModel>> getStatistics();
}
