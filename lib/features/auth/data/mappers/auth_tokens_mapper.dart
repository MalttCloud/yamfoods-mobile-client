import '../../domain/entities/auth_token.dart';
import '../models/auth_tokens_model.dart';

/// Mapper extension for [AuthTokensModel] to convert to domain entity.
extension AuthTokensModelMapper on AuthTokensModel {
  /// Converts [AuthTokensModel] to domain entity [AuthToken].
  AuthToken toDomain() =>
      AuthToken(accessToken: accessToken, refreshToken: refreshToken);
}
