import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/promo_banner_model.dart';

part 'promo_banner_api_service.g.dart';

/// Retrofit API service for promo banner endpoints.
///
/// All routes use constants from [ApiRoutes] to ensure consistency.
@RestApi()
abstract class PromoBannerApiService {
  factory PromoBannerApiService(Dio dio, {String? baseUrl}) =
      _PromoBannerApiService;

  /// Gets all active promo banners.
  ///
  /// This is an unprotected endpoint (no authentication required).
  @GET(ApiRoutes.getActivePromoBanners)
  Future<ApiResponse<List<PromoBannerModel>>> getActivePromoBanners();
}
