import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/errors/failure.dart';
import '../providers/achievement_providers.dart';
import 'achievement_transaction_item.dart';

/// Clean, modular transaction history list widget.
/// Handles its own loading and error states internally.
class AchievementTransactionHistory extends ConsumerWidget {
  const AchievementTransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(achievementHistoryProvider);

    return historyState.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: EmptyState(
              icon: Icons.history_outlined,
              title: 'No Transactions Yet',
              subtitle: 'Your transaction history will appear here',
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
            child: Container(
              //  margin: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.md),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          'Wallet Transaction History',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.txtPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Transaction list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return AchievementTransactionItem(
                        transaction: transactions[index],
                        isFirst: index == 0,
                        isLast: index == transactions.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        child: ErrorWidgett(
          icon: Icons.error_outline,
          title: 'Transaction history is unavailable for now.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(achievementHistoryProvider.future),
        ),
      ),
    );
  }
}
