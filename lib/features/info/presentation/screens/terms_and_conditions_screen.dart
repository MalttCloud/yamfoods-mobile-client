import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/info_providers.dart';
import '../widgets/terms_and_conditions_document.dart';

/// Terms and Conditions screen displaying all terms in a clean, readable format.
///
/// Features:
/// - Scrollable list of terms in a document format
/// - All content visible (PDF-like reading experience)
/// - Link support for external resources
/// - Loading, error, and empty states
class TermsAndConditionsScreen extends ConsumerWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAsync = ref.watch(termsAndConditionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Terms & Conditions'),
      body: termsAsync.when(
        data: (terms) {
          if (terms.isEmpty) {
            return EmptyState(
              icon: Icons.description_outlined,
              title: 'No Terms Available',
              subtitle: 'Terms and conditions will appear here once they are available.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(termsAndConditionsProvider.future),
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    'Please read our terms and conditions carefully',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Terms list - continuous document format
                  TermsAndConditionsDocument(terms: terms),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorWidgett(
          icon: Icons.error_outline,
          title: 'Terms could not be retrieved right now.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(termsAndConditionsProvider.future),
        ),
        loading: () => const AppLoadingIndicator(),
      ),
    );
  }
}
