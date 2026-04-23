import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_page.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = Initial;
  const factory OnboardingState.loading() = Loading;
  const factory OnboardingState.loaded({
    required List<OnboardingPage> pages,
    required int currentPageIndex,
    required PageController pageController,
  }) = Loaded;
  const factory OnboardingState.error({required Failure failure}) = ErrorState;
}
