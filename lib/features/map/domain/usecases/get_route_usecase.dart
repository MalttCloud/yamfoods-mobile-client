import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../entities/route.dart';
import '../repositories/map_repository.dart';

/// Use case for getting a route between two locations.
///
/// This encapsulates the business logic for fetching route directions.
/// It delegates to the repository which handles API calls and error transformation.
class GetRouteUsecase {
  final MapRepository _repository;

  const GetRouteUsecase(this._repository);

  /// Executes the use case to get a route between origin and destination.
  ///
  /// [origin] - The starting location
  /// [destination] - The target location
  ///
  /// Returns [Either] containing:
  /// - [Right] with [Route] on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, Route>> call(
    AddressLocation origin,
    AddressLocation destination,
  ) async {
    return await _repository.getRoute(origin, destination);
  }
}
