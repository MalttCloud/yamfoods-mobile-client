import 'package:flutter/material.dart';
import 'package:dotlottie_flutter/dotlottie_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_fonts.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../responsive.dart';
import '../../domain/entities/onboarding_page.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage onboardingPage;

  const OnboardingPageWidget({super.key, required this.onboardingPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: context.isTablet ? 0.8 : 1,
              child: _OnboardingMedia(path: onboardingPage.imagePath),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            onboardingPage.title,
            style: TextStyle(
              fontWeight: AppFontWeight.bold,
              fontSize: context.isTablet ? AppSizes.xxl : AppSizes.xl,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            onboardingPage.subtitle,
            style: TextStyle(
              fontWeight: AppFontWeight.light,
              fontSize: AppSizes.lg,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingMedia extends StatefulWidget {
  final String path;

  const _OnboardingMedia({
    required this.path,
  });

  @override
  State<_OnboardingMedia> createState() => _OnboardingMediaState();
}

class _OnboardingMediaState extends State<_OnboardingMedia> {
  bool _dotLottieLoadFailed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.path.endsWith('.lottie')) {
      if (_dotLottieLoadFailed) {
        return const _MediaFallback();
      }
      final normalizedDotLottiePath = widget.path.startsWith('assets/')
          ? widget.path.substring('assets/'.length)
          : widget.path;

      return DotLottieView(
        sourceType: 'asset',
        source: normalizedDotLottiePath,
        autoplay: true,
        loop: true,
        onLoadError: () {
          if (!mounted) {
            return;
          }
          setState(() {
            _dotLottieLoadFailed = true;
          });
          debugPrint('Failed to load dotLottie asset: ${widget.path}');
        },
      );
    }

    if (widget.path.endsWith('.json')) {
      return Lottie.asset(
        widget.path,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, stackTrace) => const _MediaFallback(),
      );
    }

    return Image.asset(
      widget.path,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const _MediaFallback(),
    );
  }
}

class _MediaFallback extends StatelessWidget {
  const _MediaFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_not_supported_outlined),
    );
  }
}
