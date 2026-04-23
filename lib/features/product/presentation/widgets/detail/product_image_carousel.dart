import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/constants/api_urls.dart';
import '../../../../../core/utils/image_url_builder.dart';
import '../../../domain/entities/product_image.dart';

/// A bowl-curved carousel for circular product images.
///
/// Displays images in a U-shaped curve where the active image
/// sits at the bottom center, and adjacent images curve upward
/// on both sides with partial visibility.
class ProductImageCarousel extends ConsumerStatefulWidget {
  final List<ProductImage> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  ConsumerState<ProductImageCarousel> createState() =>
      _ProductImageCarouselState();
}

class _ProductImageCarouselState extends ConsumerState<ProductImageCarousel> {
  late PageController _pageController;

  /// Large number to enable "infinite" scrolling in both directions.
  static const int _infiniteScrollOffset = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.65,
      initialPage: _infiniteScrollOffset,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return _buildPlaceholder();
    }

    // Sort images so main image comes first
    final sortedImages = _getSortedImages();

    return SizedBox(
      height: 380,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          // Get actual image index using modulo
          final imageIndex = index % sortedImages.length;
          final image = sortedImages[imageIndex];

          // Build image URL
          final imageUrl = ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: image.url,
          );

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              // Calculate distance from center dynamically
              double page = _infiniteScrollOffset.toDouble();
              if (_pageController.position.haveDimensions) {
                page = _pageController.page ?? _infiniteScrollOffset.toDouble();
              }
              final distance = (page - index).abs();

              return _CarouselItem(imageUrl: imageUrl, distance: distance);
            },
          );
        },
      ),
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
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.2),
        ),
        child: Icon(Icons.fastfood_outlined, color: AppColors.white, size: 60),
      ),
    );
  }
}

/// Individual carousel item with bowl-curve transforms.
class _CarouselItem extends StatelessWidget {
  final String imageUrl;
  final double distance;

  const _CarouselItem({required this.imageUrl, required this.distance});

  @override
  Widget build(BuildContext context) {
    // Clamp distance for smooth transitions
    final clampedDistance = distance.clamp(0.0, 1.0);

    // Scale: 1.0 at center, 0.55 at edges (bigger difference to keep center prominent)
    final scale = 1.0 - (clampedDistance * 0.45);

    // Y-offset: 0 at center (bottom of bowl), negative (up) at edges
    final yOffset = -clampedDistance * 70;

    // Opacity: full at center, slightly faded at edges
    final opacity = 1.0 - (clampedDistance * 0.3);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the smaller dimension to ensure a perfect circle, multiply to make center big
        final baseSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final size = baseSize * 1.2;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Center(
                child: OverflowBox(
                  maxWidth: size,
                  maxHeight: size,
                  minWidth: 0,
                  minHeight: 0,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.white.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.fastfood_outlined,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.white.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.fastfood_outlined,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
