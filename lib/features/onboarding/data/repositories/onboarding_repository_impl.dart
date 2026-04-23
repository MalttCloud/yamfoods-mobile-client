import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';
import '../mapper/onboarding_page_model_mapper.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages() async {
    final result = await localDataSource.getOnboardingPages();
    return result.map(
      (pages) => pages.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, bool>> isFirstTime() async {
    return await localDataSource.isFirstTime();
  }

  @override
  Future<Either<Failure, Unit>> setFirstTime(bool isFirstTime) async {
    return await localDataSource.setFirstTime(isFirstTime);
  }
}


