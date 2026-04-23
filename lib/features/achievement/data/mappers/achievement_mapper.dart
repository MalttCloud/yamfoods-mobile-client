import '../../domain/entities/achievement_point.dart';
import '../../domain/entities/achievement_transaction.dart';
import '../models/achievement_point_model.dart';
import '../models/achievement_transaction_model.dart';

extension AchievementPointModelMapper on AchievementPointModel {
  /// Converts data model to domain entity.
  AchievementPoint toDomain() {
    return AchievementPoint(point: point);
  }
}

extension AchievementTransactionModelMapper on AchievementTransactionModel {
  /// Converts data model to domain entity.
  AchievementTransaction toDomain() {
    return AchievementTransaction(
      id: id,
      userId: userId,
      type: type,
      points: points,
      relatedUserId: relatedUserId,
      relatedUserPhone: relatedUserPhone,
      referenceId: referenceId,
      description: description,
      createdAt: createdAt,
    );
  }
}
