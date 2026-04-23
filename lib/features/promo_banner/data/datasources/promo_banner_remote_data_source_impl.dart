import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import 'promo_banner_api_service.dart';
import 'promo_banner_remote_data_source.dart';
import '../models/promo_banner_model.dart';

/// Implementation of [PromoBannerRemoteDataSource] that handles API calls.
///
/// This class:
/// - Uses [ErrorHandler] for consistent error handling
/// - Extracts promo banner models from API response
///
/// **Error Handling:**
/// - Backend always returns HTTP error status codes (401, 404, 500, etc.) with `{success: false, error: {...}}`
/// - Retrofit throws `DioException` with `badResponse` type for non-2xx responses
/// - All errors are caught in the `catch` block and handled by `ErrorHandler.handleException()`
/// - `ApiResponse` only represents successful responses (2xx) - error case is never reached
class PromoBannerRemoteDataSourceImpl implements PromoBannerRemoteDataSource {
  final PromoBannerApiService _apiService;

  const PromoBannerRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<PromoBannerModel>>>
  getActivePromoBanners() async {
    try {
      final response = await _apiService.getActivePromoBanners();
      return Right(response.data);
    } catch (e) {
      // All error status codes (404, 401, 500, etc.) are caught here as DioException
      // ErrorHandler extracts the actual backend error message from response body
      return Left(ErrorHandler.handleException(e));
    }
  }
}
