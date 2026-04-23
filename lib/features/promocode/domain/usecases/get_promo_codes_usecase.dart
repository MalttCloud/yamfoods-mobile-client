import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/promo_code.dart';
import '../repositories/promo_code_repository.dart';

class GetPromoCodesUsecase {
  final PromoCodeRepository _repository;

  const GetPromoCodesUsecase(this._repository);

  Future<Either<Failure, List<PromoCode>>> call() async {
    return await _repository.getPromoCodes();
  }
}
