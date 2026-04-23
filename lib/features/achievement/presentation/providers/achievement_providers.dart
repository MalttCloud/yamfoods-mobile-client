import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/achievement_api_service.dart';
import '../../data/datasources/achievement_remote_data_source.dart';
import '../../data/datasources/achievement_remote_data_source_impl.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../domain/entities/achievement_point.dart';
import '../../domain/entities/achievement_transaction.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/usecases/get_achievement_point_usecase.dart';
import '../../domain/usecases/send_point_usecase.dart';
import '../../domain/usecases/get_achievement_history_usecase.dart';

part 'achievement_providers.g.dart';

@riverpod
Future<AchievementApiService> achievementApiService(Ref ref) async {
  // Use dioClientProvider (with auth interceptor) because all achievement
  // endpoints require authentication (getAchievementPoint, sendPoint, getAchievementHistory)
  final dio = await ref.watch(dioClientProvider.future);
  return AchievementApiService(dio);
}

@riverpod
Future<AchievementRemoteDataSource> achievementRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(achievementApiServiceProvider.future);
  return AchievementRemoteDataSourceImpl(apiService);
}

@riverpod
Future<AchievementRepository> achievementRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    achievementRemoteDataSourceProvider.future,
  );
  return AchievementRepositoryImpl(remoteDataSource);
}

@riverpod
Future<GetAchievementPointUsecase> getAchievementPointUseCase(Ref ref) async {
  final repository = await ref.watch(achievementRepositoryProvider.future);
  return GetAchievementPointUsecase(repository);
}

@riverpod
Future<SendPointUsecase> sendPointUseCase(Ref ref) async {
  final repository = await ref.watch(achievementRepositoryProvider.future);
  return SendPointUsecase(repository);
}

@riverpod
Future<GetAchievementHistoryUsecase> getAchievementHistoryUseCase(
  Ref ref,
) async {
  final repository = await ref.watch(achievementRepositoryProvider.future);
  return GetAchievementHistoryUsecase(repository);
}

/// FutureProvider for getting achievement points.
@riverpod
Future<AchievementPoint> achievementPoint(Ref ref) async {
  final useCase = await ref.watch(getAchievementPointUseCaseProvider.future);
  final result = await useCase.call();
  return result.fold((failure) => throw failure, (point) => point);
}

/// FutureProvider for sending points to another user.
///
/// Parameters:
/// - [point]: The number of points to send
/// - [phone]: The phone number of the recipient
@riverpod
Future<void> sendPoint(Ref ref, int point, String phone) async {
  final useCase = await ref.watch(sendPointUseCaseProvider.future);
  final result = await useCase.call(point: point, phone: phone);
  result.fold((failure) => throw failure, (_) {});
}

/// FutureProvider for getting achievement history.
@riverpod
Future<List<AchievementTransaction>> achievementHistory(Ref ref) async {
  final useCase = await ref.watch(getAchievementHistoryUseCaseProvider.future);
  final result = await useCase.call();
  return result.fold((failure) => throw failure, (history) => history);
}
