import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/terms_and_conditions.dart';
import '../repositories/info_repository.dart';

class GetTermsAndConditionsUsecase {
  final InfoRepository _repository;

  const GetTermsAndConditionsUsecase(this._repository);

  Future<Either<Failure, List<TermsAndConditions>>> call() async {
    return await _repository.getTermsAndConditions();
  }
}
