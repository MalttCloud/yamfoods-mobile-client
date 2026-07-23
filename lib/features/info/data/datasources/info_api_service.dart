import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/faq_model.dart';
import '../models/help_support_model.dart';
import '../models/privacy_policy_model.dart';
import '../models/terms_and_conditions_model.dart';

part 'info_api_service.g.dart';

@RestApi()
abstract class InfoApiService {
  factory InfoApiService(Dio dio, {String? baseUrl}) = _InfoApiService;

  @GET(ApiRoutes.getHelpSupport)
  Future<ApiResponse<HelpSupportModel>> getHelpSupport();

  @GET(ApiRoutes.getFaqs)
  Future<ApiResponse<List<FaqModel>>> getFaqs();

  @GET(ApiRoutes.getTermsAndConditions)
  Future<ApiResponse<List<TermsAndConditionsModel>>> getTermsAndConditions();

  @GET(ApiRoutes.getPrivacyPolicy)
  Future<ApiResponse<List<PrivacyPolicyModel>>> getPrivacyPolicy();

  @POST(ApiRoutes.submitFeedback)
  Future<void> submitFeedback(@Body() Map<String, dynamic> body);

  @POST(ApiRoutes.submitCollaborationRequest)
  Future<void> submitCollaborationRequest(@Body() Map<String, dynamic> body);

  @POST(ApiRoutes.deleteMyAccount)
  Future<void> deleteMyAccount(@Body() Map<String, dynamic> body);

  @POST(ApiRoutes.recordDau)
  Future<void> recordDau(@Body() Map<String, dynamic> body);
}