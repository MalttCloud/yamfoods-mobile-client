import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_page.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingPagesUsecase {
  final OnboardingRepository repository;

  GetOnboardingPagesUsecase(this.repository);

  Future<Either<Failure, List<OnboardingPage>>> call() async {
    return await repository.getOnboardingPages();
  }
}
