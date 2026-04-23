import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/info_providers.dart';
import '../widgets/help_support_content.dart';
import '../widgets/help_support_faq_entry.dart';

/// Help & Support screen.
///
/// Screen responsibility:
/// - loading / error / empty / data states
/// - header text
class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpAsync = ref.watch(helpSupportProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Help & Support'),
        body: helpAsync.when(
          data: (data) {
            // If absolutely everything is empty, show empty state.
            final hasAny =
                data.email.trim().isNotEmpty ||
                data.phone1.trim().isNotEmpty ||
                data.address.trim().isNotEmpty ||
                (data.phone2?.trim().isNotEmpty ?? false) ||
                (data.telegram?.trim().isNotEmpty ?? false) ||
                (data.instagram?.trim().isNotEmpty ?? false) ||
                (data.facebook?.trim().isNotEmpty ?? false) ||
                (data.tiktok?.trim().isNotEmpty ?? false) ||
                (data.website?.trim().isNotEmpty ?? false);
      
            if (!hasAny) {
              return EmptyState(
                icon: Icons.support_agent_rounded,
                title: 'No support info',
                subtitle: 'Support contact information will appear here once available.',
              );
            }
      
            return RefreshIndicator(
              onRefresh: () => ref.refresh(helpSupportProvider.future),
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'Need help? Contact us using any option below.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    HelpSupportFaqEntry(
                      onTap: () => context.push(RouteName.faq),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    HelpSupportContent(data: data),
                    const SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorWidgett(
            icon: Icons.error_outline,
            title: 'Error loading support info',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () => ref.refresh(helpSupportProvider.future),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

