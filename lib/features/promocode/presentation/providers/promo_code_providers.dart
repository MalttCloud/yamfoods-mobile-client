import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/promo_code_api_service.dart';
import '../../data/datasources/promo_code_remote_data_source.dart';
import '../../data/datasources/promo_code_remote_data_source_impl.dart';
import '../../data/repositories/promo_code_repository_impl.dart';
import '../../domain/entities/promo_code.dart';
import '../../domain/repositories/promo_code_repository.dart';
import '../../domain/usecases/get_promo_codes_usecase.dart';
import '../../domain/usecases/verify_promo_code_usecase.dart';

part 'promo_code_providers.g.dart';

/// Promo code API service provider
///
/// Uses dioClientProvider (with auth interceptor) because all promo code endpoints
/// require authentication.
@riverpod
Future<PromoCodeApiService> promoCodeApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return PromoCodeApiService(dio);
}

@riverpod
Future<PromoCodeRemoteDataSource> promoCodeRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(promoCodeApiServiceProvider.future);
  return PromoCodeRemoteDataSourceImpl(apiService);
}

@riverpod
Future<PromoCodeRepository> promoCodeRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    promoCodeRemoteDataSourceProvider.future,
  );
  return PromoCodeRepositoryImpl(remoteDataSource);
}

@riverpod
Future<VerifyPromoCodeUsecase> verifyPromoCodeUseCase(Ref ref) async {
  final repository = await ref.watch(promoCodeRepositoryProvider.future);
  return VerifyPromoCodeUsecase(repository);
}

@riverpod
Future<GetPromoCodesUsecase> getPromoCodesUseCase(Ref ref) async {
  final repository = await ref.watch(promoCodeRepositoryProvider.future);
  return GetPromoCodesUsecase(repository);
}

/// FutureProvider for getting all promo codes.
@riverpod
Future<List<PromoCode>> promoCodeList(Ref ref) async {
  final useCase = await ref.watch(getPromoCodesUseCaseProvider.future);
  final result = await useCase.call();
  return result.fold((failure) => throw failure, (promoCodes) => promoCodes);
}
