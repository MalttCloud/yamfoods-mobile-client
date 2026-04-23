import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_point.freezed.dart';

@freezed
sealed class AchievementPoint with _$AchievementPoint {
  const factory AchievementPoint({required int point}) = _AchievementPoint;
}
