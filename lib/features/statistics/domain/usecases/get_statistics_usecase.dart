import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/statistics_model.dart';
import '../repositories/statistics_repository.dart';

class GetStatisticsUseCase {
  final StatisticsRepository _repository;

  GetStatisticsUseCase(this._repository);

  Future<Either<Failure, StatisticsModel>> call() {
    return _repository.getStatistics();
  }
}
