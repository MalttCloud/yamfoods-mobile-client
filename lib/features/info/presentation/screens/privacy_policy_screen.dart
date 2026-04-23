import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/info_providers.dart';
import '../widgets/privacy_policy_document.dart';

/// Privacy Policy screen displaying all items in a clean, readable format.
///
/// Features:
/// - Scrollable list of privacy policy items in a document format
/// - All content visible (PDF-like reading experience)
/// - Link support for external resources
/// - Loading, error, and empty states
class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyAsync = ref.watch(privacyPolicyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Privacy Policy'),
      body: privacyAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.privacy_tip_outlined,
              title: 'No Privacy Policy Available',
              subtitle: 'Privacy policy will appear here once it is available.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(privacyPolicyProvider.future),
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please read our privacy policy carefully',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Privacy policy list - continuous document format
                  PrivacyPolicyDocument(items: items),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorWidgett(
          icon: Icons.error_outline,
          title: 'Error loading privacy policy',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(privacyPolicyProvider.future),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}

