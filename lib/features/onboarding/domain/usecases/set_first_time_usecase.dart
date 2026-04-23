import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

class SetFirstTimeUsecase {
  final OnboardingRepository repository;

  SetFirstTimeUsecase(this.repository);

  Future<Either<Failure, Unit>> call(bool isFirstTime) async {
    return await repository.setFirstTime(isFirstTime);
  }
}
