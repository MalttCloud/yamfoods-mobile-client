import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/enums/feedback_type.dart';
import '../entities/faq.dart';
import '../entities/help_support.dart';
import '../entities/privacy_policy.dart';
import '../entities/terms_and_conditions.dart';

abstract class InfoRepository {
  Future<Either<Failure, HelpSupport>> getHelpSupport();

  Future<Either<Failure, List<Faq>>> getFaqs();

  Future<Either<Failure, List<TermsAndConditions>>> getTermsAndConditions();

  Future<Either<Failure, List<PrivacyPolicy>>> getPrivacyPolicy();

  Future<Either<Failure, void>> submitFeedback({
    required FeedbackType type,
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
