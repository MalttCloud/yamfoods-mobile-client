import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../../domain/entities/route.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_data_source.dart';
import '../models/delivery_zone_model.dart';
import '../models/forward_geocoding_model.dart';
import '../models/route_model.dart';

class MapRepositoryImpl implements MapRepository {
  final MapDataSource
  mapDataSource; // Use abstract class instead of concrete implementation (DataSourceImpl)

  MapRepositoryImpl(this.mapDataSource);

  @override
  Future<Either<Failure, Route>> getRoute(
    AddressLocation origin,
    AddressLocation destination,
  ) async {
    final routeModel = await mapDataSource.getRoute(origin, destination);
    return routeModel.fold(
      (failure) => Left(failure),
      (route) => Right(route.toDomain()),
    );
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    return await mapDataSource.reverseGeocode(latitude, longitude);
  }

  @override
  Future<Either<Failure, List<DeliveryZoneModel>>> getDeliveryZones() async {
    return mapDataSource.getDeliveryZones();
  }

  @override
  Future<Either<Failure, ForwardGeocodingResponse>> searchAddress({
    required String query,
  }) async {
    return mapDataSource.searchAddress(query: query);
  }
}
