import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../providers/onboarding_notifier.dart';
import '../providers/onboarding_state.dart';

class Dot extends ConsumerWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    return state.when(
      data: (onboardingState) => onboardingState.maybeWhen(
        loaded: (pages, currentPageIndex, pageController) => Positioned(
          bottom: MediaQuery.of(context).padding.bottom + AppSizes.lg,
          left: AppSizes.lg,
          child: SmoothPageIndicator(
            controller: pageController,
            count: pages.length,
            onDotClicked: (index) =>
                ref.read(onboardingProvider.notifier).dotNavigationClick(index),
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.secondary,
              dotHeight: 6,
              dotWidth: 10,
            ),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
