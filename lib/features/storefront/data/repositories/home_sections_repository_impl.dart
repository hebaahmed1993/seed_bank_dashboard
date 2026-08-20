import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/home_sections_repository.dart';
import '../datasources/home_sections_remote_data_source.dart';
import '../models/home_section_model.dart';
class HomeSectionsRepositoryImpl implements HomeSectionsRepository {
  final HomeSectionsRemoteDataSource _remoteDataSource;

  HomeSectionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<HomeSectionModel>>> getSections() async {
    try {
      final result = await _remoteDataSource.getSections();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addSection(HomeSectionModel section) async {
    try {
      await _remoteDataSource.addSection(section);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSection(HomeSectionModel section) async {
    try {
      await _remoteDataSource.updateSection(section);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSection(String sectionId) async {
    try {
      await _remoteDataSource.deleteSection(sectionId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}