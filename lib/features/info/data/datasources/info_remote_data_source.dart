import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/faq_model.dart';
import '../models/help_support_model.dart';
import '../models/privacy_policy_model.dart';
import '../models/terms_and_conditions_model.dart';

abstract class InfoRemoteDataSource {
  Future<Either<Failure, HelpSupportModel>> getHelpSupport();

  Future<Either<Failure, List<FaqModel>>> getFaqs();

  Future<Either<Failure, List<TermsAndConditionsModel>>>
      getTermsAndConditions();

  Future<Either<Failure, List<PrivacyPolicyModel>>> getPrivacyPolicy();

  Future<Either<Failure, void>> submitFeedback({
    required String type,
    required String title,
    required String message,
  });

  Future<Either<Failure, void>> submitCollaborationRequest({
    required String name,
    required String phone,
    String? email,
    String? organization,
    String? website,
    required String title,
    required String proposal,
  });

  Future<Either<Failure, void>> deleteMyAccount({
    required String phone,
    required String title,
    required String reason,
  });

  Future<Either<Failure, void>> recordDau();
}
