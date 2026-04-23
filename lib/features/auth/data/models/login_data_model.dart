// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';
part 'login_data_model.freezed.dart';
part 'login_data_model.g.dart';

@freezed
sealed class LoginDataModel with _$LoginDataModel {
  const factory LoginDataModel({
    required String message,
    required UserModel user,
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'refreshToken') required String refreshToken,
  }) = _LoginDataModel;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);

  const LoginDataModel._();
}
