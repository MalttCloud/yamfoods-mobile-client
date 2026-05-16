// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AchievementTransactionModel _$AchievementTransactionModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_AchievementTransactionModel', json, ($checkedConvert) {
  final val = _AchievementTransactionModel(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    userId: $checkedConvert('userId', (v) => (v as num).toInt()),
    type: $checkedConvert('type', (v) => v as String),
    achievmentType: $checkedConvert('achievmentType', (v) => v as String?),
    points: $checkedConvert('points', (v) => (v as num).toInt()),
    relatedUserId: $checkedConvert(
      'relatedUserId',
      (v) => (v as num?)?.toInt(),
    ),
    relatedUserPhone: $checkedConvert('relatedUserPhone', (v) => v as String?),
    referenceId: $checkedConvert('referenceId', (v) => (v as num?)?.toInt()),
    description: $checkedConvert('description', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$AchievementTransactionModelToJson(
  _AchievementTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': instance.type,
  'achievmentType': instance.achievmentType,
  'points': instance.points,
  'relatedUserId': instance.relatedUserId,
  'relatedUserPhone': instance.relatedUserPhone,
  'referenceId': instance.referenceId,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
};
