import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/datasources/onboarding_local_data_source_impl.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/get_onboarding_pages_usecase.dart';
import '../../domain/usecases/is_first_time_usecase.dart';
import '../../domain/usecases/set_first_time_usecase.dart';

part 'onboarding_providers.g.dart';

// ==================== Data Sources ====================

@riverpod
OnboardingLocalDataSource onboardingLocalDataSource(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return OnboardingLocalDataSourceImpl(storage);
}

// ==================== Repository ====================

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  final localDataSource = ref.watch(onboardingLocalDataSourceProvider);
  return OnboardingRepositoryImpl(localDataSource);
}

// ==================== UseCases ====================

@riverpod
GetOnboardingPagesUsecase getOnboardingPagesUsecase(Ref ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingPagesUsecase(repository);
}

@riverpod
IsFirstTimeUsecase isFirstTimeUsecase(Ref ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return IsFirstTimeUsecase(repository);
}

@riverpod
SetFirstTimeUsecase setFirstTimeUsecase(Ref ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return SetFirstTimeUsecase(repository);
}
