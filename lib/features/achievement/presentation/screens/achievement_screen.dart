import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/error_widget.dart';
import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/achievement_providers.dart';
import '../widgets/achievement_wallet_card.dart';
import '../widgets/achievement_transaction_history.dart';

/// Achievement screen displaying premium wallet card and transaction history.
class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementPointState = ref.watch(achievementPointProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Your Wallet Balance'),
      body: achievementPointState.when(
        data: (achievementPoint) => Column(
          children: [
            // Fixed wallet card at the top
            Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.xl,
                bottom: AppSizes.xl,
              ),
              child: AchievementWalletCard(achievementPoint: achievementPoint),
            ),
            // Scrollable transaction history
            Expanded(
              child: SingleChildScrollView(
                //physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + AppSizes.xl,
                  ),
                  child: const AchievementTransactionHistory(),
                ),
              ),
            ),
          ],
        ),
        loading: () => const AppLoadingIndicator(),
        error: (error, stackTrace) => ErrorWidgett(
          icon: Icons.error_outline,
          title: 'Your wallet balance is taking longer to load.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(achievementPointProvider.future),
        ),
      ),
    );
  }
}
