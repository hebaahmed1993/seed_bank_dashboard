import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/supplier_model.dart';
import '../repositories/suppliers_repository.dart';

class AddSupplierUseCase {
  final SuppliersRepository _repository;

  AddSupplierUseCase(this._repository);

  Future<Either<Failure, void>> execute(SupplierModel supplier) async {
    return await _repository.addSupplier(supplier);
  }
}