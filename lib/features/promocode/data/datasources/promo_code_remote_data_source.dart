import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/promo_code_model.dart';
import '../models/promo_code_verification_result_model.dart';

abstract class PromoCodeRemoteDataSource {
  Future<Either<Failure, PromoCodeVerificationResultModel>> verifyPromoCode({
    required String code,
    required double orderAmount,
  });
  Future<Either<Failure, List<PromoCodeModel>>> getPromoCodes();
}
