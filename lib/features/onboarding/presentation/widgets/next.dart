
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/theme/app_sizes.dart';
import '../providers/onboarding_notifier.dart';
import '../providers/onboarding_state.dart';

class Next extends ConsumerWidget {
  final VoidCallback onNavigate;

  const Next({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    return state.when(
      data: (onboardingState) => onboardingState.maybeWhen(
        loaded: (pages, currentPageIndex, pageController) => Positioned(
          right: AppSizes.lg,
          bottom: MediaQuery.of(context).padding.bottom + AppSizes.sm,
          child: CustomButton(
            text: currentPageIndex == pages.length - 1 ? 'Get Started' : 'Next',
            onPressed: onNavigate,
            width: 150,
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
