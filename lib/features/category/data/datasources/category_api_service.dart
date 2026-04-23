import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/categories_response_model.dart';

part 'category_api_service.g.dart';

@RestApi()
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio, {String? baseUrl}) = _CategoryApiService;

  @GET(ApiRoutes.getAllCategories)
  Future<ApiResponse<CategoriesResponseModel>> getAllCategories(
    @Path('branchId') int branchId,
  );
}
