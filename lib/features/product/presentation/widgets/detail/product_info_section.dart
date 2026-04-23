import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/extensions/product_pricing_extensions.dart';

/// Clean, professional product info section.
///
/// Displays name, rating, price, and stock status with
/// refined typography and minimal decoration.
class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Row
          Row(
            children: [
              // Star Rating (5 stars visual)
              RatingBarIndicator(
                rating: _parseRating(product.averageRating),
                itemBuilder: (context, index) =>
                    const Icon(Icons.star_rounded, color: AppColors.warning),
                unratedColor: AppColors.grey.withValues(alpha: 0.25),
                itemCount: 5,
                itemSize: 28,
              ),

              const SizedBox(width: AppSizes.sm),

              // Rating number
              Text(
                _formatRating(product.averageRating),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtPrimary,
                ),
              ),

              // Dot separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: AppColors.grey.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ),

              // Review count
              Text(
                '${product.reviewCount} reviews',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.txtSecondary.withValues(alpha: 0.7),
                ),
              ),

              const Spacer(),

              // Stock indicator
              _buildStockBadge(),
            ],
          ).animate().fadeIn(duration: 350.ms, delay: 100.ms),

          const SizedBox(height: AppSizes.md),

          // Product Name
          Text(
                product.name,
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              )
              .animate()
              .fadeIn(duration: 350.ms, delay: 150.ms)
              .slideX(begin: -0.02, end: 0, curve: Curves.easeOut),

          const SizedBox(height: AppSizes.lg),

          // Price Section
          _buildPriceRow().animate().fadeIn(duration: 350.ms, delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildStockBadge() {
    final inStock = product.quantity > 0;
    final lowStock =
        product.quantity > 0 && product.quantity <= product.minimumThreshold;

    final color = inStock
        ? (lowStock ? AppColors.warning : AppColors.success)
        : AppColors.error;

    final text = inStock
        ? (lowStock ? 'Low Stock' : 'In Stock')
        : 'Out of Stock';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 2,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildPriceRow() {
    if (product.hasDiscount) {
      final saved = product.originalPriceValue - product.discountedPriceValue;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Discounted Price
              Text(
                '${product.discountedPriceValue.toStringAsFixed(2)} ETB',
                style: AppTextStyles.h4,
              ),

              const SizedBox(width: AppSizes.md),

              // Original Price
              Text(
                '${product.originalPriceValue.toStringAsFixed(2)} ETB',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.grey,
                ),
              ),

              const SizedBox(width: AppSizes.md),

              // Discount Badge - Eye-catching design
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm - 2,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_offer_rounded,
                      color: AppColors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.discountPercent.round()}% OFF',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.xs),

          // Savings text
          Text(
            'You save ${saved.toStringAsFixed(2)} ETB ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Regular Price (no discount)
    return Text(
      '${product.price} ETB',
      style: AppTextStyles.h1.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: -1,
      ),
    );
  }

  double _parseRating(String rating) {
    try {
      return double.parse(rating).clamp(0.0, 5.0);
    } catch (e) {
      return 0.0;
    }
  }

  String _formatRating(String rating) {
    try {
      final ratingValue = double.parse(rating);
      return ratingValue.toStringAsFixed(1);
    } catch (e) {
      return '0.0';
    }
  }
}
