import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/home_section_model.dart';
import '../../domain/repositories/home_sections_repository.dart';

class UpdateHomeSectionUseCase {
  final HomeSectionsRepository _repository;

  UpdateHomeSectionUseCase(this._repository);

  Future<Either<Failure, void>> call(HomeSectionModel section) {
    return _repository.updateSection(section);
  }
}
