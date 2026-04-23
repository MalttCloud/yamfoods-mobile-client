import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'onboarding_providers.dart';
import 'onboarding_state.dart';

part 'onboarding_notifier.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Future<OnboardingState> build() async {
    state = const AsyncValue.data(OnboardingState.loading());
    final getOnboardingPagesUsecase = ref.read(
      getOnboardingPagesUsecaseProvider,
    );
    final result = await getOnboardingPagesUsecase();
    return result.fold(
      (failure) => OnboardingState.error(failure: failure),
      (pages) => OnboardingState.loaded(
        pages: pages,
        currentPageIndex: 0,
        pageController: PageController(),
      ),
    );
  }

  void updatePageIndicator(int index) {
    state.whenData((currentState) {
      currentState.maybeWhen(
        loaded: (pages, currentPageIndex, pageController) {
          state = AsyncValue.data(
            OnboardingState.loaded(
              pages: pages,
              currentPageIndex: index,
              pageController: pageController,
            ),
          );
        },
        orElse: () {},
      );
    });
  }

  void dotNavigationClick(int index) {
    state.whenData((currentState) {
      currentState.maybeWhen(
        loaded: (pages, currentPageIndex, pageController) {
          state = AsyncValue.data(
            OnboardingState.loaded(
              pages: pages,
              currentPageIndex: index,
              pageController: pageController,
            ),
          );
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        orElse: () {},
      );
    });
  }

  Future<bool> nextPage() async {
    bool shouldNavigate = false;
    final currentState = state.value;
    if (currentState != null) {
      await currentState.maybeWhen(
        loaded: (pages, currentPageIndex, pageController) async {
          if (currentPageIndex == pages.length - 1) {
            final setFirstTimeUsecase = ref.read(setFirstTimeUsecaseProvider);
            final result = await setFirstTimeUsecase(false);
            await result.fold(
              (failure) async {
                state = AsyncValue.data(
                  OnboardingState.error(failure: failure),
                );
              },
              (_) async {
                shouldNavigate = true;
                pageController.dispose();
              },
            );
          } else {
            state = AsyncValue.data(
              OnboardingState.loaded(
                pages: pages,
                currentPageIndex: currentPageIndex + 1,
                pageController: pageController,
              ),
            );
            await pageController.animateToPage(
              currentPageIndex + 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        orElse: () async {},
      );
    }
    return shouldNavigate;
  }

  Future<bool> skipPage() async {
    final setFirstTimeUsecase = ref.read(setFirstTimeUsecaseProvider);
    final result = await setFirstTimeUsecase(false);
    bool shouldNavigate = false;
    result.fold(
      (failure) =>
          state = AsyncValue.data(OnboardingState.error(failure: failure)),
      (_) {
        shouldNavigate = true;
        state.whenData((currentState) {
          currentState.maybeWhen(
            loaded: (pages, currentPageIndex, pageController) {
              pageController.dispose();
            },
            orElse: () {},
          );
        });
      },
    );
    return shouldNavigate;
  }
}
