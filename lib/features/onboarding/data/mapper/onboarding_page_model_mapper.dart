import '../../domain/entities/onboarding_page.dart';
import '../models/onboarding_page_model.dart';

extension OnboardingPageModelMapper on OnboardingPageModel {
  OnboardingPage toEntity() =>
      OnboardingPage(imagePath: imagePath, title: title, subtitle: subtitle);
}
