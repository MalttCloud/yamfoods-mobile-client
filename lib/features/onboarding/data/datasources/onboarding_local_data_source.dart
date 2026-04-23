import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/onboarding_page_model.dart';

abstract class OnboardingLocalDataSource {
  Future<Either<Failure, List<OnboardingPageModel>>> getOnboardingPages();
  Future<Either<Failure, bool>> isFirstTime();
  Future<Either<Failure, Unit>> setFirstTime(bool isFirstTime);
}
