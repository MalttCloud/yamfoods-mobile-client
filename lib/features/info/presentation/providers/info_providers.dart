import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../../../core/enums/feedback_type.dart';
import '../../data/datasources/info_api_service.dart';
import '../../data/datasources/info_remote_data_source.dart';
import '../../data/datasources/info_remote_data_source_impl.dart';
import '../../data/repositories/info_repository_impl.dart';
import '../../domain/entities/faq.dart';
import '../../domain/entities/help_support.dart';
import '../../domain/entities/privacy_policy.dart';
import '../../domain/entities/terms_and_conditions.dart';
import '../../domain/repositories/info_repository.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/get_help_support_usecase.dart';
import '../../domain/usecases/get_privacy_policy_usecase.dart';
import '../../domain/usecases/get_terms_and_conditions_usecase.dart';
import '../../domain/usecases/submit_feedback_usecase.dart';

part 'info_providers.g.dart';

// ==================== Data Sources ====================

/// Info API service provider
///
/// Uses dioClientProvider (with auth interceptor) so we can send Authorization
/// header when available (and support protected endpoints like feedback).
@riverpod
Future<InfoApiService> infoApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return InfoApiService(dio);
}

/// Info remote data source provider
@riverpod
Future<InfoRemoteDataSource> infoRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(infoApiServiceProvider.future);
  return InfoRemoteDataSourceImpl(apiService);
}

// ==================== Repository ====================

/// Info repository provider
@riverpod
Future<InfoRepository> infoRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(infoRemoteDataSourceProvider.future);
  return InfoRepositoryImpl(remoteDataSource);
}

// ==================== UseCases ====================

/// Get help support usecase provider
@riverpod
Future<GetHelpSupportUsecase> getHelpSupportUsecase(Ref ref) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  return GetHelpSupportUsecase(repository);
}

/// Get FAQs usecase provider
@riverpod
Future<GetFaqsUsecase> getFaqsUsecase(Ref ref) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  return GetFaqsUsecase(repository);
}

/// Get terms and conditions usecase provider
@riverpod
Future<GetTermsAndConditionsUsecase> getTermsAndConditionsUsecase(
  Ref ref,
) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  return GetTermsAndConditionsUsecase(repository);
}

/// Get privacy policy usecase provider
@riverpod
Future<GetPrivacyPolicyUsecase> getPrivacyPolicyUsecase(Ref ref) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  return GetPrivacyPolicyUsecase(repository);
}

/// Submit feedback usecase provider
@riverpod
Future<SubmitFeedbackUsecase> submitFeedbackUsecase(Ref ref) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  return SubmitFeedbackUsecase(repository);
}

// ==================== Data Providers ====================

/// Help support provider
///
/// Fetches help & support information using the usecase.
/// Returns [AsyncValue<HelpSupport>] which handles loading, error, and data states.
@riverpod
Future<HelpSupport> helpSupport(Ref ref) async {
  final usecase = await ref.watch(getHelpSupportUsecaseProvider.future);
  final result = await usecase.call();

  return result.fold((failure) => throw failure, (helpSupport) => helpSupport);
}

/// FAQs list provider
///
/// Fetches all FAQs using the usecase.
/// Returns [AsyncValue<List<Faq>>] which handles loading, error, and data states.
@riverpod
Future<List<Faq>> faqs(Ref ref) async {
  final usecase = await ref.watch(getFaqsUsecaseProvider.future);
  final result = await usecase.call();

  return result.fold((failure) => throw failure, (faqs) => faqs);
}

/// Terms and conditions list provider
///
/// Fetches all terms and conditions using the usecase.
/// Returns [AsyncValue<List<TermsAndConditions>>] which handles loading, error, and data states.
@riverpod
Future<List<TermsAndConditions>> termsAndConditions(Ref ref) async {
  final usecase = await ref.watch(getTermsAndConditionsUsecaseProvider.future);
  final result = await usecase.call();

  return result.fold((failure) => throw failure, (terms) => terms);
}

/// Privacy policy list provider
///
/// Fetches all privacy policy items using the usecase.
/// Returns [AsyncValue<List<PrivacyPolicy>>] which handles loading, error, and data states.
@riverpod
Future<List<PrivacyPolicy>> privacyPolicy(Ref ref) async {
  final usecase = await ref.watch(getPrivacyPolicyUsecaseProvider.future);
  final result = await usecase.call();

  return result.fold(
    (failure) => throw failure,
    (privacyPolicies) => privacyPolicies,
  );
}

// ==================== Mutations ====================

/// Parameters for submitting feedback
typedef SubmitFeedbackParams = ({
  FeedbackType type,
  String title,
  String message,
});

/// Parameters for deleting account
typedef DeleteMyAccountParams = ({String phone, String title, String reason});

/// Submit feedback provider (family)
@riverpod
Future<void> submitFeedback(Ref ref, SubmitFeedbackParams params) async {
  final usecase = await ref.watch(submitFeedbackUsecaseProvider.future);
  final result = await usecase.call(
    type: params.type,
    title: params.title,
    message: params.message,
  );
  return result.fold((failure) => throw failure, (_) => null);
}

Future<void> deleteMyAccountMutation(
  WidgetRef ref,
  DeleteMyAccountParams params,
) async {
  final repository = await ref.watch(infoRepositoryProvider.future);
  final result = await repository.deleteMyAccount(
    phone: params.phone,
    title: params.title,
    reason: params.reason,
  );
  return result.fold((failure) => throw failure, (_) => null);
}
