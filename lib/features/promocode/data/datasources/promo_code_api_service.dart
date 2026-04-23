import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/promo_code_model.dart';
import '../models/promo_code_verification_result_model.dart';

part 'promo_code_api_service.g.dart';

@RestApi()
abstract class PromoCodeApiService {
  factory PromoCodeApiService(Dio dio, {String? baseUrl}) =
      _PromoCodeApiService;

  @POST(ApiRoutes.verifyPromoCode)
  Future<ApiResponse<PromoCodeVerificationResultModel>> verifyPromoCode(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiRoutes.getPromoCodes)
  Future<ApiResponse<List<PromoCodeModel>>> getPromoCodes();
}
