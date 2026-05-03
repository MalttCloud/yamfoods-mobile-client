import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yamfoods_customer_app/app/components/app_loading_indicator.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/info_providers.dart';
import '../widgets/faq_list.dart';

/// FAQ screen.
///
/// Screen responsibility:
/// - loading / error / empty / data states
/// - header text
class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'FAQs'),
      body: faqsAsync.when(
        data: (faqs) {
          if (faqs.isEmpty) {
            return EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'No FAQs Available',
              subtitle: 'Frequently asked questions will appear here once available.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(faqsProvider.future),
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.md),
                      Text(
                        'Frequently asked questions',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      FaqList(faqs: faqs),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorWidgett(
          icon: Icons.error_outline,
          title: 'We could not pull the latest FAQs.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(faqsProvider.future),
        ),
        loading: () => AppLoadingIndicator(),
      ),
    );
  }
}

