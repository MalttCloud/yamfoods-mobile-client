import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/forward_geocoding_model.dart';
import '../models/reverse_geocoding_model.dart';
import '../models/route_model.dart';

part 'map_api_service.g.dart';

/// Retrofit API service for map/direction endpoints.
///
/// This service connects to the external Gebeta Map API.
/// All routes use query parameters for direction requests.
@RestApi(baseUrl: 'https://mapapi.gebeta.app/api')
abstract class MapApiService {
  factory MapApiService(Dio dio, {String? baseUrl}) = _MapApiService;

  /// Gets direction route between two locations.
  ///
  /// [originLat] - Origin latitude
  /// [originLng] - Origin longitude
  /// [destLat] - Destination latitude
  /// [destLng] - Destination longitude
  /// [apiKey] - API key for authentication
  /// [instruction] - Whether to include instructions (0 = no, 1 = yes)
  @GET('/route/direction/')
  Future<RouteModel> getDirectionRoute(
    @Query('origin') String origin,
    @Query('destination') String destination,
    @Query('apiKey') String apiKey,
    @Query('instruction') int instruction,
  );

  /// Gets reverse geocoding information for a given latitude and longitude.
  ///
  /// [lat] - Latitude coordinate
  /// [lon] - Longitude coordinate
  /// [format] - Response format (e.g., 'json')
  /// [apiKey] - API key for authentication
  /*
  When you provide a full URL (starting with http:// or https://), Retrofit uses that URL directly and ignores the @RestApi(baseUrl: ...) for that specific method.
  This means:
  You can keep both endpoints in the same service class
  The direction route endpoint uses the base URL (https://mapapi.gebeta.app/api)
  The reverse geocoding endpoint uses the full URL (https://api.geoapify.com/v1/geocode/reverse)
    */
  @GET('https://api.geoapify.com/v1/geocode/reverse')
  Future<ReverseGeocodingModel> reverseGeocode(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('format') String format,
    @Query('apiKey') String apiKey,
  );

  @GET('https://mapapi.gebeta.app/v2/search/geocode')
  Future<ForwardGeocodingResponse> searchAddress({
    @Query('query') required String query,
    @Query('apiKey') required String apiKey,
    @Query('country') String country = 'et',
    @Query('limit') int limit = 10,
    @Query('autocomplete') bool autocomplete = true,
  });

 
}
