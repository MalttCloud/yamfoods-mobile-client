// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'achievement_transaction_model.dart';

part 'achievement_history_response_model.freezed.dart';
part 'achievement_history_response_model.g.dart';

@freezed
sealed class AchievementHistoryResponseModel
    with _$AchievementHistoryResponseModel {
  const factory AchievementHistoryResponseModel({
    required List<AchievementTransactionModel> transaction,
  }) = _AchievementHistoryResponseModel;

  factory AchievementHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementHistoryResponseModelFromJson(json);
}
