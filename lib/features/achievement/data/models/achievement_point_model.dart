// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_point_model.freezed.dart';
part 'achievement_point_model.g.dart';

@freezed
sealed class AchievementPointModel with _$AchievementPointModel {
  const factory AchievementPointModel({required int point}) =
      _AchievementPointModel;

  factory AchievementPointModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementPointModelFromJson(json);
}
