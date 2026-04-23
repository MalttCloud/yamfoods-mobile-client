// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code_model.freezed.dart';
part 'promo_code_model.g.dart';

@freezed
sealed class PromoCodeModel with _$PromoCodeModel {
  const factory PromoCodeModel({
    required int id,
    required String code,
    required String discount,
    @JsonKey(name: 'minOrderAmount') required int minOrderQty,
    @JsonKey(name: 'startDate') required DateTime startDate,
    @JsonKey(name: 'endDate') required DateTime endDate,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _PromoCodeModel;

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) =>
      _$PromoCodeModelFromJson(json);
}
