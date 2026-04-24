// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
sealed class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required int id,
    @JsonKey(name: 'productId') required int productId,
    @JsonKey(name: 'reviewerId') required int reviewerId,
    @JsonKey(name: 'reviewerName') String? reviewerName,
    int? rating,
    String? reviewerImageUrl,
    String? comment,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}
