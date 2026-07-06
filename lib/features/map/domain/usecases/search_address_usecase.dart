import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/forward_geocoding_model.dart';
import '../repositories/map_repository.dart';

class SearchAddressUsecase {
  final MapRepository _repository;

  const SearchAddressUsecase(this._repository);

  Future<Either<Failure, ForwardGeocodingResponse>> call(String query) async {
    return _repository.searchAddress(query: query);
  }
}
