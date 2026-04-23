import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/promo_code.dart';
import '../entities/promo_code_verification_result.dart';

abstract class PromoCodeRepository {
  Future<Either<Failure, PromoCodeVerificationResult>> verifyPromoCode({
    required String code,
    required double orderAmount,
  });
  Future<Either<Failure, List<PromoCode>>> getPromoCodes();
}
