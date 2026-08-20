import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_data_source.dart';
import '../models/statistics_model.dart';

/// Repository Implementation.
///
/// Architectural rule: this is the ONLY layer that catches exceptions.
/// It maps them to `Left(ServerFailure)` so the domain/presentation layers
/// deal exclusively with `Either<Failure, StatisticsModel>`.
class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    try {
      final statistics = await _remoteDataSource.getStatistics();
      return Right(statistics);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
