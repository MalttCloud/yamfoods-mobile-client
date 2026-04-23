import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_request_data.freezed.dart';

/// Data model for creating or updating a review.
@freezed
sealed class ReviewRequestData with _$ReviewRequestData {
  const factory ReviewRequestData({
    required int productId,
    required int rating,
    required String comment,
  }) = _ReviewRequestData;
}
