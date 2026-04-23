import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../core/constants/api_urls.dart';
import '../../../../../core/utils/image_url_builder.dart';
import '../../../domain/entities/product_image.dart';

/// Modern professional image carousel for product detail screen.
///
/// Features:
/// - Full-width images covering the upper section
/// - Rounded bottom corners (left and right)
/// - Dot indicators at the bottom
/// - Smooth page transitions
/// - Premium, modern design without background colors
class ProductImageCarouselModern extends ConsumerStatefulWidget {
  final List<ProductImage> images;

  const ProductImageCarouselModern({super.key, required this.images});

  @override
  ConsumerState<ProductImageCarouselModern> createState() =>
      _ProductImageCarouselModernState();
}

class _ProductImageCarouselModernState
    extends ConsumerState<ProductImageCarouselModern> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return _buildPlaceholder();
    }

    // Sort images so main image comes first
    final sortedImages = _getSortedImages();

    return Stack(
      children: [
        // Image carousel
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: sortedImages.length,
            itemBuilder: (context, index) {
              final image = sortedImages[index];
              final imageUrl = ImageUrlBuilder.build(
                baseUrl: ApiUrls.getPortalImageBaseUrl(),
                imagePath: image.url,
              );

              return _ImageItem(
                imageUrl: imageUrl,
                isFirst: index == 0,
                isLast: index == sortedImages.length - 1,
              );
            },
          ),
        ),

        // Dot indicators positioned at bottom with backdrop for visibility
        if (sortedImages.length > 1)
          Positioned(
            bottom: AppSizes.lg,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: sortedImages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.white,
                    dotColor: AppColors.white.withValues(alpha: 0.5),
                    dotHeight: 6,
                    dotWidth: 6,
                    spacing: 6,
                    expansionFactor: 3,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Sorts images with main image first.
  List<ProductImage> _getSortedImages() {
    final images = List<ProductImage>.from(widget.images);
    images.sort((a, b) {
      if (a.isMain && !b.isMain) return -1;
      if (!a.isMain && b.isMain) return 1;
      return 0;
    });
    return images;
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusLg),
          bottomRight: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.fastfood_outlined,
          color: AppColors.grey.withValues(alpha: 0.3),
          size: 60,
        ),
      ),
    );
  }
}

/// Individual image item with rounded bottom corners.
class _ImageItem extends StatelessWidget {
  final String imageUrl;
  final bool isFirst;
  final bool isLast;

  const _ImageItem({
    required this.imageUrl,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusLg),
          bottomRight: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusLg),
          bottomRight: Radius.circular(AppSizes.radiusLg),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.grey.withValues(alpha: 0.1),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.grey.withValues(alpha: 0.1),
            child: Center(
              child: Icon(
                Icons.fastfood_outlined,
                color: AppColors.grey.withValues(alpha: 0.3),
                size: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
