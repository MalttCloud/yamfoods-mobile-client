import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/address_model.dart';

part 'address_api_service.g.dart';

@RestApi()
abstract class AddressApiService {
  factory AddressApiService(Dio dio, {String? baseUrl}) = _AddressApiService;

  @GET(ApiRoutes.getAddresses)
  Future<ApiResponse<List<AddressModel>>> getAddresses();

  @POST(ApiRoutes.createAddress)
  Future<ApiResponse<AddressModel>> createAddress(
    @Body() Map<String, dynamic> body,
  );

  @PUT(ApiRoutes.updateAddress)
  Future<ApiResponse<AddressModel>> updateAddress(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  /// Returns void on success, throws [DioException] on failure.
  @DELETE(ApiRoutes.deleteAddress)
  Future<void> deleteAddress(@Path('id') int id);
}
