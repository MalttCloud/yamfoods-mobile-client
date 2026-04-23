import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../models/promo_code_model.dart';
import '../models/promo_code_verification_result_model.dart';
import 'promo_code_api_service.dart';
import 'promo_code_remote_data_source.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - [ApiResponse] only represents successful responses (2xx)
class PromoCodeRemoteDataSourceImpl implements PromoCodeRemoteDataSource {
  final PromoCodeApiService _apiService;

  const PromoCodeRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, PromoCodeVerificationResultModel>> verifyPromoCode({
    required String code,
    required double orderAmount,
  }) async {
    try {
      final requestData = {'code': code, 'orderAmount': orderAmount};
      final body = RequestWrapper.wrap(requestData);

      final response = await _apiService.verifyPromoCode(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<PromoCodeModel>>> getPromoCodes() async {
    try {
      final response = await _apiService.getPromoCodes();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
