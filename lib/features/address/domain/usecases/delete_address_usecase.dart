import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/address_repository.dart';

class DeleteAddressUsecase {
  final AddressRepository _repository;

  const DeleteAddressUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) async {
    return await _repository.deleteAddress(id);
  }
}
