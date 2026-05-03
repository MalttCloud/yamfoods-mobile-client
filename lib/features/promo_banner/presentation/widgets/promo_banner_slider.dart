import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/components/skeleton/promo_banner_skeleton.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../responsive.dart';
import '../providers/promo_banner_providers.dart';
import 'promo_banner_item.dart';

/// Promo banner slider widget with auto-scroll and manual control.
///
/// Features:
/// - Horizontal scrolling with fixed height
/// - Auto-scroll every 4 seconds
/// - Pauses on user interaction
/// - Resumes after 5 seconds of inactivity
/// - Page indicators at the bottom
class PromoBannerSlider extends ConsumerStatefulWidget {
  const PromoBannerSlider({super.key});

  @override
  ConsumerState<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends ConsumerState<PromoBannerSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _isAutoPlayPaused = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });

    // Pause auto-play if user manually scrolled
    if (reason == CarouselPageChangedReason.manual) {
      _pauseAutoPlay();
    }
  }

  void _pauseAutoPlay() {
    if (!_isAutoPlayPaused) {
      setState(() {
        _isAutoPlayPaused = true;
      });
      // Resume auto-play after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _isAutoPlayPaused = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(activePromoBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Carousel slider
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: banners.length,
              itemBuilder: (context, index, realIndex) {
                return PromoBannerItem(
                  key: ValueKey('banner_${banners[index].id}'),
                  banner: banners[index],
                );
              },
              options: CarouselOptions(
                height: context.isTablet ? 150 : 110,
                viewportFraction:
                    0.94, // Minimize gap while showing small preview of adjacent banners
                enlargeCenterPage: true, // Enable scale animation
                enlargeStrategy:
                    CenterPageEnlargeStrategy.scale, // Smooth scale animation
                autoPlay: !_isAutoPlayPaused && banners.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  _onPageChanged(index, reason);
                },
                enableInfiniteScroll: banners.length > 1,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
              ),
            ),
            SizedBox(height: AppSizes.md),
            // Page indicators
            if (banners.length > 1)
              AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: banners.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.white.withValues(alpha: 0.7),
                  dotHeight: 6,
                  dotWidth: 10,
                  spacing: 6,
                  // Larger expansion for active dot (3.5x width = 28px)
                ),
              ),
          ],
        );
      },
      loading: () => const PromoBannerSkeleton(),
      error: (error, stackTrace) => const PromoBannerSkeleton(),
    );
  }
}
