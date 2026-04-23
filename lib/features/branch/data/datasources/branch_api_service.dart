import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/branches_response_model.dart';

part 'branch_api_service.g.dart';

/// Retrofit API service for branch endpoints.
///
/// All routes use constants from [ApiRoutes] to ensure consistency.
@RestApi()
abstract class BranchApiService {
  factory BranchApiService(Dio dio, {String? baseUrl}) = _BranchApiService;

  /// Gets all branches.
  ///
  /// This is an unprotected endpoint (no authentication required).
  @GET(ApiRoutes.getAllBranches)
  Future<ApiResponse<BranchesResponseModel>> getAllBranches();
}
