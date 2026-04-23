import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../branch/presentation/providers/branch_providers.dart';
import '../../category/presentation/providers/category_providers.dart';
import '../../product/presentation/providers/product_providers.dart';
import '../../promo_banner/presentation/providers/promo_banner_providers.dart';
import '../../promo_banner/presentation/widgets/promo_banner_slider.dart';
import '../widgets/category_chips_list.dart';
import '../widgets/draggable_telegram_fab.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/popular_section.dart';
import '../widgets/product_sliver_grid.dart';
import '../widgets/special_offer_for_you_section.dart';

/// Home screen displaying products organized by category.
///
/// Premium design with fixed header and scrollable content below.
/// Uses CustomScrollView with slivers for optimal performance.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current branch ID - guaranteed to exist since branch selection is enforced
    final branchId = ref.watch(currentBranchProvider)!;

    Future<void> onHomePageRefresh() {
      return Future.wait<void>([
        ref.refresh(branchProductsProvider(branchId).future),
        ref.refresh(categoriesProvider(branchId).future),
        ref.refresh(activePromoBannersProvider.future),
        ref.refresh(discountedProductsProvider(branchId).future),
        ref.refresh(featuredProductsProvider(branchId).future),
      ]);
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primary,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(180),
            child: Container(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  const HomeHeader(),
                  Container(
                    padding: EdgeInsets.only(bottom: AppSizes.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: const HomeSearchBar(),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: onHomePageRefresh,
                child: CustomScrollView(
                  slivers: [
                    // Premium surface section (banner, categories) with gradient
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.9),
                              AppColors.background,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 2),
                            // Promo banner slider
                            const PromoBannerSlider(),

                            SizedBox(height: AppSizes.lg),

                            // Category chips list
                            CategoryChipsList(branchId: branchId),
                          ],
                        ),
                      ),
                    ),

                    // Special offer + Popular with gradient (primary → white) like top section
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpecialOfferForYouSection(branchId: branchId),
                            PopularSection(branchId: branchId),
                          ],
                        ),
                      ),
                    ),

                    // Product grid - scrolls with content
                    ProductSliverGrid(branchId: branchId),

                    // Bottom padding for safe area (background so content area ends on white)
                    SliverToBoxAdapter(
                      child: Container(
                        color: AppColors.background,
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).padding.bottom +
                              AppSizes.lg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Positioned.fill(child: DraggableTelegramFab()),
      ],
    );
  }
}
