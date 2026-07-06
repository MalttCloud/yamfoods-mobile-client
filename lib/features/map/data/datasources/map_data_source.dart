import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../models/delivery_zone_model.dart';
import '../models/forward_geocoding_model.dart';
import '../models/route_model.dart';

abstract class MapDataSource {
  Future<Either<Failure, RouteModel>> getRoute(
    AddressLocation origin,
    AddressLocation destination,
  );

  Future<Either<Failure, String>> reverseGeocode(
    double latitude,
    double longitude,
  );

  Future<Either<Failure, ForwardGeocodingResponse>> searchAddress({
    required String query,
  });

  Future<Either<Failure, List<DeliveryZoneModel>>> getDeliveryZones();
}
