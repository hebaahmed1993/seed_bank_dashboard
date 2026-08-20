import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/home_section_model.dart';


abstract class HomeSectionsRepository {

  Future<Either<Failure, List<HomeSectionModel>>> getSections();
  Future<Either<Failure, void>> addSection(HomeSectionModel section);

  Future<Either<Failure, void>> updateSection(HomeSectionModel section);

  Future<Either<Failure, void>> deleteSection(String sectionId);
}
