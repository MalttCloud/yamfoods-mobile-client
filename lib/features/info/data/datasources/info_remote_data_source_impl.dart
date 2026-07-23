import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../models/faq_model.dart';
import '../models/help_support_model.dart';
import '../models/privacy_policy_model.dart';
import '../models/terms_and_conditions_model.dart';
import 'info_api_service.dart';
import 'info_remote_data_source.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
class InfoRemoteDataSourceImpl implements InfoRemoteDataSource {
  final InfoApiService _apiService;

  const InfoRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, HelpSupportModel>> getHelpSupport() async {
    try {
      final response = await _apiService.getHelpSupport();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<FaqModel>>> getFaqs() async {
    try {
      final response = await _apiService.getFaqs();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TermsAndConditionsModel>>>
      getTermsAndConditions() async {
    try {
      final response = await _apiService.getTermsAndConditions();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<PrivacyPolicyModel>>> getPrivacyPolicy() async {
    try {
      final response = await _apiService.getPrivacyPolicy();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback({
    required String type,
    required String title,
    required String message,
  }) async {
    try {
      final requestData = {'type': type, 'title': title, 'message': message};
      final body = RequestWrapper.wrap(requestData);

      await _apiService.submitFeedback(body);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
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
    try {
      final requestData = <String, dynamic>{
        'name': name,
        'phone': phone,
        'title': title,
        'proposal': proposal,
      };
      final e = email?.trim();
      if (e != null && e.isNotEmpty) requestData['email'] = e;
      final org = organization?.trim();
      if (org != null && org.isNotEmpty) {
        requestData['organization'] = org;
      }
      final w = website?.trim();
      if (w != null && w.isNotEmpty) requestData['website'] = w;

      final body = RequestWrapper.wrap(requestData);
      await _apiService.submitCollaborationRequest(body);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMyAccount({
    required String phone,
    required String title,
    required String reason,
  }) async {
    try {
      final requestData = {'phone': phone, 'title': title, 'reason': reason};
      final body = RequestWrapper.wrap(requestData);

      await _apiService.deleteMyAccount(body);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> recordDau() async {
    
    try {
      final body = RequestWrapper.wrap({'platform': 'MOBILE'});
      print('DAC request body: $body');
      await _apiService.recordDau(body);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
