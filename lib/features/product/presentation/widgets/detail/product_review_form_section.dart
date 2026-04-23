import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/components/custom_button.dart';
import '../../../../../app/components/input_textfield.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/snackbar_service.dart';
import '../../../../auth/presentation/providers/auth_user_state.dart';
import '../../../../review/domain/entities/review_request_data.dart';
import '../../../../review/presentation/providers/review_loading_providers.dart';
import '../../../../review/presentation/providers/review_notifier.dart';

/// Review form section for authenticated users without a review.
///
/// Shows rating stars and comment field, allowing users to submit a review.
/// Only displayed if user is authenticated and doesn't have a review yet.
class ProductReviewFormSection extends ConsumerStatefulWidget {
  final int productId;

  const ProductReviewFormSection({super.key, required this.productId});

  @override
  ConsumerState<ProductReviewFormSection> createState() =>
      _ProductReviewFormSectionState();
}

class _ProductReviewFormSectionState
    extends ConsumerState<ProductReviewFormSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentController;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_rating == 0.0) {
      final snackbar = ref.read(snackbarServiceProvider);
      snackbar.showError(
        const Failure.validation(message: 'Please select a rating'),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final data = ReviewRequestData(
        productId: widget.productId,
        rating: _rating.toInt(),
        comment: _commentController.text.trim(),
      );

      await ref.read(reviewProvider(widget.productId).notifier).create(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final reviewsAsync = ref.watch(reviewProvider(widget.productId));

    // Only show if user is authenticated
    if (!isAuthenticated || currentUser == null) {
      return const SizedBox.shrink();
    }

    return reviewsAsync.when(
      data: (reviews) {
        // Check if user already has a review
        final hasUserReview = reviews.any(
          (review) => review.reviewerId == currentUser.id,
        );

        // Don't show form if user already has a review
        if (hasUserReview) {
          return const SizedBox.shrink();
        }

        final isCreating = ref.watch(reviewCreateLoadingProvider);

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
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
                    // Section Title
                    Text(
                      'Write a Review',
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // Form Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Label
                      Text(
                        'Rating *',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),

                      // Rating Stars
                      Center(
                        child: RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 40,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: AppSizes.lg),

                      // Comment Field
                      Text(
                        'Comment *',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.txtSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      InputTextfield(
                        controller: _commentController,
                        hintText: 'Write your review...',
                        icon: Icons.comment_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a comment';
                          }
                          if (value.trim().length < 3) {
                            return 'Comment must be at least 3 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLength: 100,
                        maxLines: 4,
                      ),

                      const SizedBox(height: AppSizes.lg),

                      // Submit Button
                      CustomButton(
                        text: 'Submit Review',
                        onPressed: _handleSubmit,
                        isLoading: isCreating,
                        loadingText: 'Submitting...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
