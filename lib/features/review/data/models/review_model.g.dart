// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModel _$ReviewModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReviewModel', json, ($checkedConvert) {
  final val = _ReviewModel(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    productId: $checkedConvert('productId', (v) => (v as num).toInt()),
    reviewerId: $checkedConvert('reviewerId', (v) => (v as num).toInt()),
    reviewerName: $checkedConvert('reviewerName', (v) => v as String?),
    rating: $checkedConvert('rating', (v) => (v as num?)?.toInt()),
    reviewerImageUrl: $checkedConvert('reviewerImageUrl', (v) => v as String?),
    comment: $checkedConvert('comment', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'reviewerId': instance.reviewerId,
      'reviewerName': instance.reviewerName,
      'rating': instance.rating,
      'reviewerImageUrl': instance.reviewerImageUrl,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
