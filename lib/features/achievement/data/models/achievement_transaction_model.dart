// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_transaction_model.freezed.dart';
part 'achievement_transaction_model.g.dart';

@freezed
sealed class AchievementTransactionModel with _$AchievementTransactionModel {
  const factory AchievementTransactionModel({
    required int id,
    @JsonKey(name: 'userId') required int userId,
    required String type,
    String? achievmentType,
    required int points,
    @JsonKey(name: 'relatedUserId') int? relatedUserId,
    @JsonKey(name: 'relatedUserPhone') String? relatedUserPhone,
    @JsonKey(name: 'referenceId') int? referenceId,
    String? description,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _AchievementTransactionModel;

  factory AchievementTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementTransactionModelFromJson(json);
}
