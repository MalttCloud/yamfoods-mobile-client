import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../../data/models/delivery_zone_model.dart';
import '../../data/models/forward_geocoding_model.dart';
import '../entities/route.dart';

abstract class MapRepository {
  Future<Either<Failure, Route>> getRoute(
    AddressLocation origin,
    AddressLocation destination,
  );

  Future<Either<Failure, String>> reverseGeocode(
    double latitude,
    double longitude,
  );

  Future<Either<Failure, List<DeliveryZoneModel>>> getDeliveryZones();

  Future<Either<Failure, ForwardGeocodingResponse>> searchAddress({
    required String query,
  });
}
