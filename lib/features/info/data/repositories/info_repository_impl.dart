import 'package:dartz/dartz.dart';

import '../../../../core/enums/feedback_type.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/faq.dart';
import '../../domain/entities/help_support.dart';
import '../../domain/entities/privacy_policy.dart';
import '../../domain/entities/terms_and_conditions.dart';
import '../../domain/repositories/info_repository.dart';
import '../datasources/info_remote_data_source.dart';
import '../mappers/faq_mapper.dart';
import '../mappers/help_support_mapper.dart';
import '../mappers/privacy_policy_mapper.dart';
import '../mappers/terms_and_conditions_mapper.dart';

/// Maps data models to domain entities and coordinates data sources.
///
/// Errors from data sources are propagated without transformation.
class InfoRepositoryImpl implements InfoRepository {
  final InfoRemoteDataSource _remoteDataSource;

  const InfoRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HelpSupport>> getHelpSupport() async {
    final result = await _remoteDataSource.getHelpSupport();

    return result.fold(
      (failure) => Left(failure),
      (helpSupportModel) => Right(helpSupportModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, List<Faq>>> getFaqs() async {
    final result = await _remoteDataSource.getFaqs();

    return result.fold(
      (failure) => Left(failure),
      (faqModels) {
        final faqs = faqModels.map((model) => model.toDomain()).toList();
        return Right(faqs);
      },
    );
  }

  @override
  Future<Either<Failure, List<TermsAndConditions>>>
      getTermsAndConditions() async {
    final result = await _remoteDataSource.getTermsAndConditions();

    return result.fold(
      (failure) => Left(failure),
      (termsModels) {
        final terms = termsModels.map((model) => model.toDomain()).toList();
        return Right(terms);
      },
    );
  }

  @override
  Future<Either<Failure, List<PrivacyPolicy>>> getPrivacyPolicy() async {
    final result = await _remoteDataSource.getPrivacyPolicy();

    return result.fold(
      (failure) => Left(failure),
      (privacyModels) {
        final privacyPolicies =
            privacyModels.map((model) => model.toDomain()).toList();
        return Right(privacyPolicies);
      },
    );
  }

  @override
  Future<Either<Failure, void>> submitFeedback({
    required FeedbackType type,
    required String title,
    required String message,
  }) async {
    final result = await _remoteDataSource.submitFeedback(
      type: type.apiValue,
      title: title,
      message: message,
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> submitCollaborationRequest({
    required String name,
    required String phone,
    String? email,
    String? organization,
    String? website,
    required String title,
    required String proposal,
  }) async {
    final result = await _remoteDataSource.submitCollaborationRequest(
      name: name,
      phone: phone,
      email: email,
      organization: organization,
      website: website,
      title: title,
      proposal: proposal,
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> deleteMyAccount({
    required String phone,
    required String title,
    required String reason,
  }) async {
    final result = await _remoteDataSource.deleteMyAccount(
      phone: phone,
      title: title,
      reason: reason,
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> recordDau() async {
    return _remoteDataSource.recordDau();
  }
}
