import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_transaction.freezed.dart';

@freezed
sealed class AchievementTransaction with _$AchievementTransaction {
  const factory AchievementTransaction({
    required int id,
    required int userId,
    required String type,
    String? achievmentType,
    required int points,
    int? relatedUserId,
    String? relatedUserPhone,
    int? referenceId,
    String? description,
    required DateTime createdAt,
  }) = _AchievementTransaction;
}
