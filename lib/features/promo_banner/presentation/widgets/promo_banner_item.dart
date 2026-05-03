import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../domain/entities/promo_banner.dart';

class PromoBannerItem extends ConsumerWidget {
  final PromoBanner banner;

  const PromoBannerItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ImageUrlBuilder.build(
      baseUrl: ApiUrls.getPortalImageBaseUrl(),
      imagePath: banner.imageUrl,
    );

    void onTap() {
      if (banner.productId != null) {
        context.push(RouteName.productDetail, extra: banner.productId);
      }
    }

    final hasAction = banner.productId != null;

    return GestureDetector(
      onTap: hasAction ? onTap : null,
      child: Container(
        width: double.infinity,
        height:  AppSizes.bannerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  key: ValueKey(imageUrl),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth:
                      (MediaQuery.of(context).size.width * 2).round(),
                  memCacheHeight: (AppSizes.bannerHeight * 2).round(),
                  maxWidthDiskCache: 2000,
                  maxHeightDiskCache: 1000,
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 100),
                  placeholderFadeInDuration: const Duration(
                    milliseconds: 150,
                  ),
                  useOldImageOnUrlChange: true,
                  placeholder: (context, url) => Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: AppColors.txtSecondary,
                      ),
                    ),
                  ),
                )
              : Container(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: AppColors.txtSecondary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
