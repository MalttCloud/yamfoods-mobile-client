import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/snacks/error_snack_bar.dart';
import '../providers/onboarding_notifier.dart';
import '../providers/onboarding_state.dart';
import '../widgets/dots.dart';
import '../widgets/next.dart';
import '../widgets/pages.dart';
import '../widgets/skip.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.when(
        data: (onboardingState) => onboardingState.when(
          initial: () => const AppLoadingIndicator(),
          loading: () => const AppLoadingIndicator(),
          loaded: (pages, currentPageIndex, pageController) => Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) => ref
                    .read(onboardingProvider.notifier)
                    .updatePageIndicator(index),
                itemBuilder: (context, index) =>
                    OnboardingPageWidget(onboardingPage: pages[index]),
              ),
              const Dot(),
              Skip(
                onNavigate: () async {
                  final shouldNavigate = await ref
                      .read(onboardingProvider.notifier)
                      .skipPage();
                  if (shouldNavigate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        context.go(RouteName.branches);
                      }
                    });
                  }
                },
              ),
              Next(
                onNavigate: () async {
                  bool shouldNavigate = await ref
                      .read(onboardingProvider.notifier)
                      .nextPage();
                  if (shouldNavigate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        context.go(RouteName.branches);
                      }
                    });
                  }
                },
              ),
            ],
          ),
          error: (failure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ErrorSnackBar.show(context, failure: failure);
                context.go(RouteName.branches);
              }
            });
            return const AppLoadingIndicator();
          },
        ),
        error: (error, stack) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ErrorSnackBar.show(
                context,
                failure: Failure.unexpected(message: error.toString()),
              );
              context.go(RouteName.branches);
            }
          });
          return const AppLoadingIndicator();
        },
        loading: () => const AppLoadingIndicator(),
      ),
    );
  }
}
