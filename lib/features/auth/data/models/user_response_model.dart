/// Minimal wrapper model for endpoints that return user data.
///
/// Backend returns: `{ "user": {...} }`
/// This model is only used for JSON parsing in the data layer.
/// It's not exposed to the domain layer - we extract the user immediately.
library;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'user_response_model.freezed.dart';
part 'user_response_model.g.dart';

@freezed
sealed class UserResponseModel with _$UserResponseModel {
  const factory UserResponseModel({required UserModel user}) =
      _UserResponseModel;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  const UserResponseModel._();
}
