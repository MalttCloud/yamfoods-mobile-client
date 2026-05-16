import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/promo_code_providers.dart';
import '../widgets/promo_code_card.dart';

/// Screen listing all available promo codes for the user.
class PromoCodeListScreen extends ConsumerWidget {
  const PromoCodeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoCodesState = ref.watch(promoCodeListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Promo Codes'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xl,
        ),
        child: promoCodesState.when(
          data: (promoCodes) {
            if (promoCodes.isEmpty) {
              return const EmptyState(
                icon: Icons.local_offer_outlined,
                title: 'No promo codes available',
                subtitle: 'Check back later for new offers',
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.defaultMaxScreenWidth,
                ),
                child: ListView.builder(
                  itemCount: promoCodes.length,
                  itemBuilder: (context, index) {
                    return PromoCodeCard(promoCode: promoCodes[index]);
                  },
                ),
              ),
            );
          },
          loading: () => const AppLoadingIndicator(),
          error: (error, stackTrace) => ErrorWidgett(
            icon: Icons.error_outline,
            title: 'We could not load promo codes.',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () => ref.refresh(promoCodeListProvider.future),
          ),
        ),
      ),
    );
  }
}
