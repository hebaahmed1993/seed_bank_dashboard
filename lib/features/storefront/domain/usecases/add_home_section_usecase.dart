import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/home_section_model.dart';
import '../../domain/repositories/home_sections_repository.dart';

class AddHomeSectionUseCase {
  final HomeSectionsRepository _repository;

  AddHomeSectionUseCase(this._repository);

  Future<Either<Failure, void>> call(HomeSectionModel section) {
    return _repository.addSection(section);
  }
}
