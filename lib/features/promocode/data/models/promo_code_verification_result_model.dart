// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'promo_code_model.dart';

part 'promo_code_verification_result_model.freezed.dart';
part 'promo_code_verification_result_model.g.dart';

@freezed
sealed class PromoCodeVerificationResultModel
    with _$PromoCodeVerificationResultModel {
  const factory PromoCodeVerificationResultModel({
    @JsonKey(name: 'isValid') required bool isValid,
    required String discount,
    required PromoCodeModel promo,
  }) = _PromoCodeVerificationResultModel;

  factory PromoCodeVerificationResultModel.fromJson(
    Map<String, dynamic> json,
  ) => _$PromoCodeVerificationResultModelFromJson(json);
}
