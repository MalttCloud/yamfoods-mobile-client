import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../app/theme/app_images.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/errors/failure.dart';
import '../models/onboarding_page_model.dart';
import 'onboarding_local_data_source.dart';

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage secureStorage;

  OnboardingLocalDataSourceImpl(this.secureStorage);

  @override
  Future<Either<Failure, List<OnboardingPageModel>>>
  getOnboardingPages() async {
    try {
      return Right([
        const OnboardingPageModel(
          imagePath: AppImages.onboardingImg1,
          title: AppTexts.onboardingTitle1,
          subtitle: AppTexts.onboardingSubtitle1,
        ),
        const OnboardingPageModel(
          imagePath: AppImages.onboardingImg2,
          title: AppTexts.onboardingTitle2,
          subtitle: AppTexts.onboardingSubtitle2,
        ),
        const OnboardingPageModel(
          imagePath: AppImages.onboardingImg3,
          title: 'Fast Delivery, Fresh Food',
          subtitle: AppTexts.onboardingSubtitle3,
        ),
      ]);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFirstTime() async {
    try {
      final value = await secureStorage.read(key: 'isFirstTime');
      return Right(value == null || value == 'true');
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setFirstTime(bool isFirstTime) async {
    try {
      await secureStorage.write(
        key: 'isFirstTime',
        value: isFirstTime.toString(),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }
}
