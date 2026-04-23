import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

class IsFirstTimeUsecase {
  final OnboardingRepository repository;

  IsFirstTimeUsecase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isFirstTime();
  }
}
