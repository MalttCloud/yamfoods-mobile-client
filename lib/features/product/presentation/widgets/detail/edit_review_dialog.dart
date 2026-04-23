import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/components/custom_button.dart';
import '../../../../../app/components/input_textfield.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../review/domain/entities/review.dart';
import '../../../../review/domain/entities/review_request_data.dart';
import '../../../../review/presentation/providers/review_events.dart';
import '../../../../review/presentation/providers/review_loading_providers.dart';
import '../../../../review/presentation/providers/review_notifier.dart';

class EditReviewDialog extends ConsumerStatefulWidget {
  final Review review;
  final int productId;

  const EditReviewDialog({
    super.key,
    required this.review,
    required this.productId,
  });

  /// Shows the edit review dialog.
  ///
  /// Returns `true` if review was updated, `false` if cancelled, `null` if dismissed.
  static Future<bool?> show({
    required BuildContext context,
    required Review review,
    required int productId,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) =>
          EditReviewDialog(review: review, productId: productId),
    );
  }

  @override
  ConsumerState<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends ConsumerState<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.review.comment);
    _rating = widget.review.rating.toDouble();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final data = ReviewRequestData(
        productId: widget.productId,
        rating: _rating.toInt(),
        comment: _commentController.text.trim(),
      );

      await ref
          .read(reviewProvider(widget.productId).notifier)
          .updateReview(id: widget.review.id, data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ReviewUiEvent?>(reviewUiEventsProvider, (previous, next) {
      if (next == null) return;

      if (next is ReviewUpdated) {
        if (context.mounted && context.canPop()) {
          context.pop(true);
        }
      }
    });

    final isUpdating = ref
        .watch(reviewUpdateLoadingProvider)
        .contains(widget.review.id);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      contentPadding: EdgeInsets.all(AppSizes.lg),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xl,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Edit Review',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: AppSizes.xl),

              // Rating
              Text(
                'Rating *',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star_rounded, color: AppColors.warning),
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

              const SizedBox(height: AppSizes.xl),

              // Update Button
              CustomButton(
                text: 'Update Review',
                onPressed: _handleSubmit,
                isLoading: isUpdating,
                loadingText: 'Updating...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
