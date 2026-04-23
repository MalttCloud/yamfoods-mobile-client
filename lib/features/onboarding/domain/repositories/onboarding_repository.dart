import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_page.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages();
  Future<Either<Failure, bool>> isFirstTime();
  Future<Either<Failure, Unit>> setFirstTime(bool isFirstTime);
}
