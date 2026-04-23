import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/privacy_policy.dart';
import '../repositories/info_repository.dart';

class GetPrivacyPolicyUsecase {
  final InfoRepository _repository;

  const GetPrivacyPolicyUsecase(this._repository);

  Future<Either<Failure, List<PrivacyPolicy>>> call() async {
    return await _repository.getPrivacyPolicy();
  }
}
