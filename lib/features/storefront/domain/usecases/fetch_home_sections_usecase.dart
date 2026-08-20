import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/home_sections_repository.dart';

import '../../data/models/home_section_model.dart';

class FetchHomeSectionsUseCase {
  final HomeSectionsRepository _repository;

  FetchHomeSectionsUseCase(this._repository);

  Future<Either<Failure, List<HomeSectionModel>>> call() {
    return _repository.getSections();
  }
}
