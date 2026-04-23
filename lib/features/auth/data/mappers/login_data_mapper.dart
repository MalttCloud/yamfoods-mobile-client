import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../models/login_data_model.dart';
import 'user_mapper.dart';

/// Mapper extension for [LoginDataModel] to convert to domain entities.
extension LoginDataMapper on LoginDataModel {
  /// Converts [LoginDataModel] to domain entities (User and AuthToken).
  (User user, AuthToken tokens) toDomain() {
    return (
      user.toDomain(),
      AuthToken(accessToken: accessToken, refreshToken: refreshToken),
    );
  }
}
