import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetAddressesUsecase {
  final AddressRepository _repository;

  const GetAddressesUsecase(this._repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await _repository.getAddresses();
  }
}
