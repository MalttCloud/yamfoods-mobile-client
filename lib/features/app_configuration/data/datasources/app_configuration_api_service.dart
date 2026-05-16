import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/app_configuration_model.dart';
import '../models/order_type_config_model.dart';

part 'app_configuration_api_service.g.dart';

@RestApi()
abstract class AppConfigurationApiService {
  factory AppConfigurationApiService(Dio dio, {String? baseUrl}) =
      _AppConfigurationApiService;

  @GET(ApiRoutes.getAppConfiguration)
  Future<ApiResponse<AppConfigurationModel>> getAppConfiguration();

  @GET(ApiRoutes.getOrderTypes)
  Future<ApiResponse<List<OrderTypeConfigModel>>> getOrderTypes();
}
