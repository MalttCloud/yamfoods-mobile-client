//import 'dart:developer' as developer;

import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:yamfoods_customer_app/features/map/data/models/delivery_zone_model.dart';
import 'package:yamfoods_customer_app/features/map/data/models/forward_geocoding_model.dart';

import '../../../../core/constants/gebeta_map_config.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../models/route_model.dart';
import 'map_api_service.dart';
import 'map_data_source.dart';
import 'mock_delivery_zone.dart';

/// Handles map API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - Map API errors are automatically detected and mapped to [Failure.mapError]
///   by [ErrorHandler] based on the request URL
class MapDataSourceImpl implements MapDataSource {
  final MapApiService _apiService;

  const MapDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, RouteModel>> getRoute(
    AddressLocation origin,
    AddressLocation destination,
  ) async {
    try {
      final originStr = '${origin.latitude},${origin.longitude}';
      final destStr = '${destination.latitude},${destination.longitude}';

      final response = await _apiService.getDirectionRoute(
        originStr,
        destStr,
        GebetaMapConfig.apiKey,
        0, // No instructions for simplicity
      );

      // DEBUG: Print full polyline without truncation
      developer.log(
        'Route direction polyline (${response.direction.length} points): ${response.direction}',
        name: 'MapDataSource',
      );

      return Right(response);
    } catch (e) {
      // All errors (DioException, parsing errors, etc.) are handled by ErrorHandler
      // ErrorHandler automatically detects map API errors and maps them to Failure.mapError
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _apiService.reverseGeocode(
        latitude,
        longitude,
        'json',
        GebetaMapConfig.geoapifyApiKey,
      );

      // Return the first formatted address, or empty string if no results
      if (response.formattedAddresses.isEmpty) {
        return const Left(
          Failure.mapError('No address found for the given coordinates'),
        );
      }

      return Right(response.formattedAddresses.first);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<DeliveryZoneModel>>> getDeliveryZones() async{
    try {
      // Mock data
      await Future.delayed(const Duration(milliseconds: 500));

        return Right(deliveryZones);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ForwardGeocodingResponse>> searchAddress({required String query}) async {
    try {
      final response = await _apiService.searchAddress(
        query: query,
        apiKey: GebetaMapConfig.apiKey,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
