import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/promo_code_verification_result.dart';
import '../repositories/promo_code_repository.dart';

class VerifyPromoCodeUsecase {
  final PromoCodeRepository _repository;

  const VerifyPromoCodeUsecase(this._repository);

  Future<Either<Failure, PromoCodeVerificationResult>> call({
    required String code,
    required double orderAmount,
  }) async {
    return await _repository.verifyPromoCode(
      code: code,
      orderAmount: orderAmount,
    );
  }
}
