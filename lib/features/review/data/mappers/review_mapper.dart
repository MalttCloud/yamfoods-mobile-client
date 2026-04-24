import '../../domain/entities/review.dart';
import '../models/review_model.dart';

extension ReviewModelMapper on ReviewModel {
  /// Converts data model to domain entity.
  /// Applies default values for nullable fields.
  Review toDomain() {
    return Review(
      id: id,
      productId: productId,
      reviewerId: reviewerId,
      reviewerName: reviewerName ?? 'N/A',
      rating: rating ?? 0,
      comment: comment ?? 'N/A',
      reviewerImageUrl: reviewerImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
