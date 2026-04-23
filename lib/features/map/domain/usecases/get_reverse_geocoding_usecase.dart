import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/map_repository.dart';

class GetReverseGeocodingUsecase {
  final MapRepository _repository;

  const GetReverseGeocodingUsecase(this._repository);

  Future<Either<Failure, String>> call(
    double latitude,
    double longitude,
  ) async {
    return await _repository.reverseGeocode(latitude, longitude);
  }
}
