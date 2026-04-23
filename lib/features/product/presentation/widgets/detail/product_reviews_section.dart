import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/components/confirmation_dialog.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../auth/presentation/providers/auth_user_state.dart';
import '../../../../review/domain/entities/review.dart';
import '../../../../review/presentation/providers/review_notifier.dart';
import 'edit_review_dialog.dart';

/// Product reviews section displaying user reviews.
///
/// Shows reviews with user avatar (first character), name, time ago,
/// star rating, and comment. Initially shows 2 reviews with a "See more" button.
/// Shrinks to zero height on error or empty state.
class ProductReviewsSection extends ConsumerStatefulWidget {
  final int productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  ConsumerState<ProductReviewsSection> createState() =>
      _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends ConsumerState<ProductReviewsSection> {
  bool _showAll = false;
  static const int _initialDisplayCount = 2;

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewProvider(widget.productId));
    final currentUser = ref.watch(currentUserProvider);

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort reviews: user's review first (if authenticated)
        final sortedReviews = _sortReviews(reviews, currentUser?.id);

        final displayedReviews = _showAll
            ? sortedReviews
            : sortedReviews.take(_initialDisplayCount).toList();
        final remainingCount = sortedReviews.length - displayedReviews.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title with count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical accent bar (wall) - matches title height
                  Container(
                    width: 4,
                    height: 24,
                    margin: const EdgeInsets.only(right: AppSizes.sm, top: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Section Title with count
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Reviews',
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm + 2,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                          child: Text(
                            '${reviews.length}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Reviews List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              itemCount: displayedReviews.length,
              itemBuilder: (context, index) {
                final review = displayedReviews[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: _ReviewItem(
                    review: review,
                    productId: widget.productId,
                    currentUserId: currentUser?.id,
                  ),
                );
              },
            ),

            // See more button
            if (remainingCount > 0 && !_showAll)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xl,
                  vertical: AppSizes.md,
                ),
                child: GestureDetector(
                  onTap: () => setState(() => _showAll = true),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'See more ($remainingCount)',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  /// Sorts reviews so user's review appears first.
  List<Review> _sortReviews(List<Review> reviews, int? userId) {
    if (userId == null) return reviews;

    final userReview = reviews.where((r) => r.reviewerId == userId).toList();
    final otherReviews = reviews.where((r) => r.reviewerId != userId).toList();

    return [...userReview, ...otherReviews];
  }
}

/// Individual review item widget.
class _ReviewItem extends ConsumerWidget {
  final Review review;
  final int productId;
  final int? currentUserId;

  const _ReviewItem({
    required this.review,
    required this.productId,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this is the current user's review
    final isUserReview =
        currentUserId != null && review.reviewerId == currentUserId;

    // Get first character of reviewer name
    final firstChar = review.reviewerName.isNotEmpty
        ? review.reviewerName[0].toUpperCase()
        : '?';

    // Format name (e.g., "Rejeb Dendir" → "Rejeb D.")
    final formattedName = _formatName(review.reviewerName);

    // Format time ago
    final timeAgo = DateFormatter.formatTimeAgo(review.createdAt);

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar (first character)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                firstChar,
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.md),

          // Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, rating stars, and edit/delete icons on same row
                Row(
                  children: [
                    Text(
                      formattedName,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    // Star rating
                    RatingBarIndicator(
                      rating: review.rating.toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                      ),
                      unratedColor: AppColors.grey.withValues(alpha: 0.25),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    // Edit/Delete icons (only for user's review)
                    if (isUserReview) ...[
                      const SizedBox(width: AppSizes.sm),
                      GestureDetector(
                        onTap: () => _handleEdit(context, ref),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.xs),
                      GestureDetector(
                        onTap: () => _handleDelete(context, ref),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppSizes.xs),

                // Time ago (where rating was)
                Text(
                  timeAgo,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.7),
                  ),
                ),

                const SizedBox(height: AppSizes.sm),

                // Comment
                Text(
                  review.comment,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats name: "Rejeb Dendir" → "Rejeb D.", "Rejeb" → "Rejeb"
  String _formatName(String fullName) {
    if (fullName.isEmpty) return 'Anonymous';

    final parts = fullName
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'Anonymous';
    if (parts.length == 1) return parts[0];

    // First name + first letter of second name + dot
    final firstName = parts[0];
    final secondNameFirstChar = parts[1][0].toUpperCase();
    return '$firstName $secondNameFirstChar.';
  }

  /// Shows edit review dialog.
  Future<void> _handleEdit(BuildContext context, WidgetRef ref) async {
    await EditReviewDialog.show(
      context: context,
      review: review,
      productId: productId,
    );
  }

  /// Shows delete confirmation and deletes review.
  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Review?',
      message:
          'Are you sure you want to delete your review? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmButtonColor: AppColors.error,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(reviewProvider(productId).notifier).delete(id: review.id);
    }
  }
}
