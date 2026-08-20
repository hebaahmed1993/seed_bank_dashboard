import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/home_sections_repository.dart';

class DeleteHomeSectionUseCase {
  final HomeSectionsRepository _repository;

  DeleteHomeSectionUseCase(this._repository);

  Future<Either<Failure, void>> call(String sectionId) {
    return _repository.deleteSection(sectionId);
  }
}
