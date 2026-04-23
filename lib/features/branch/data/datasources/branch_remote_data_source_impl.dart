import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import 'branch_api_service.dart';
import 'branch_remote_data_source.dart';
import '../models/branch_model.dart';

/// Implementation of [BranchRemoteDataSource] that handles API calls.
///
/// This class:
/// - Uses [ErrorHandler] for consistent error handling
/// - Extracts branch models from API response
///
/// **Error Handling:**
/// - Backend always returns HTTP error status codes (401, 404, 500, etc.) with `{success: false, error: {...}}`
/// - Retrofit throws `DioException` with `badResponse` type for non-2xx responses
/// - All errors are caught in the `catch` block and handled by `ErrorHandler.handleException()`
/// - `ApiResponse` only represents successful responses (2xx) - error case is never reached
class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final BranchApiService _apiService;

  const BranchRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<BranchModel>>> getAllBranches() async {
    try {
      final response = await _apiService.getAllBranches();
      return Right(response.data.branches);
    } catch (e) {
      // All error status codes (404, 401, 500, etc.) are caught here as DioException
      // ErrorHandler extracts the actual backend error message from response body
      return Left(ErrorHandler.handleException(e));
    }
  }
}
