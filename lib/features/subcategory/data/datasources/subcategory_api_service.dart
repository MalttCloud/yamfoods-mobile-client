import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/subcategories_response_model.dart';

part 'subcategory_api_service.g.dart';

@RestApi()
abstract class SubcategoryApiService {
  factory SubcategoryApiService(Dio dio, {String? baseUrl}) =
      _SubcategoryApiService;

  @GET(ApiRoutes.getAllSubcategories)
  Future<ApiResponse<SubcategoriesResponseModel>> getAllSubcategories(
    @Path('branchId') int branchId,
    @Path('categoryId') int categoryId,
  );
}
