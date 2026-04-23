import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/datasources/profile_api_service.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/datasources/profile_remote_data_source_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';

part 'profile_providers.g.dart';

// ==================== Data Sources ====================

/// Profile API service provider
///
/// Provides Retrofit API service for profile endpoints.
/// Uses dioClientProvider (with auth interceptor) because all profile endpoints
/// require authentication:
/// - getProfile, updateProfile, changePassword
@riverpod
Future<ProfileApiService> profileApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return ProfileApiService(dio);
}

/// Profile remote data source provider
///
/// Provides implementation for fetching profile data from backend.
@riverpod
Future<ProfileRemoteDataSource> profileRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(profileApiServiceProvider.future);
  return ProfileRemoteDataSourceImpl(apiService);
}

// ==================== Repository ====================

/// Profile repository provider
///
/// Provides the main repository for profile operations.
@riverpod
Future<ProfileRepository> profileRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    profileRemoteDataSourceProvider.future,
  );
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
}

// ==================== UseCases ====================

/// Get profile usecase provider
///
/// Provides usecase for fetching the current user's profile.
@riverpod
Future<GetProfileUseCase> getProfileUseCase(Ref ref) async {
  final repository = await ref.watch(profileRepositoryProvider.future);
  return GetProfileUseCase(repository);
}

/// Update profile usecase provider
///
/// Provides usecase for updating the user's profile information.
@riverpod
Future<UpdateProfileUseCase> updateProfileUseCase(Ref ref) async {
  final repository = await ref.watch(profileRepositoryProvider.future);
  return UpdateProfileUseCase(repository);
}

/// Change password usecase provider
///
/// Provides usecase for changing the user's password.
@riverpod
Future<ChangePasswordUseCase> changePasswordUseCase(Ref ref) async {
  final repository = await ref.watch(profileRepositoryProvider.future);
  return ChangePasswordUseCase(repository);
}

/// Simple FutureProvider for fetching profile data
/// No need for events or loading state - just async data
@riverpod
Future<User> userProfile(Ref ref) async {
  final getProfile = await ref.watch(getProfileUseCaseProvider.future);
  final result = await getProfile.call();
  return result.fold((failure) => throw failure, (profile) => profile);
}
