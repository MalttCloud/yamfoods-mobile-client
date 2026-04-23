import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/review_model.dart';

part 'review_api_service.g.dart';

@RestApi()
abstract class ReviewApiService {
  factory ReviewApiService(Dio dio, {String? baseUrl}) = _ReviewApiService;

  @GET(ApiRoutes.getAllReviews)
  Future<ApiResponse<List<ReviewModel>>> getAllReviews(
    @Path('productId') int productId,
  );

  @POST(ApiRoutes.createReview)
  Future<ApiResponse<ReviewModel>> createReview(
    @Body() Map<String, dynamic> body,
  );

  @PUT(ApiRoutes.updateReview)
  Future<ApiResponse<ReviewModel>> updateReview(
    @Path('reviewId') int reviewId,
    @Body() Map<String, dynamic> body,
  );

  /// Returns void on success, throws [DioException] on failure.
  @DELETE(ApiRoutes.deleteReview)
  Future<void> deleteReview(@Path('reviewId') int reviewId);
}
