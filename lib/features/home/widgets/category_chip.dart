import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/responsive.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../category/domain/entities/category.dart';

/// Individual category chip widget.
///
/// Displays a circular category image with name below it.
/// Styled for premium surface with white/semi-transparent colors.
class CategoryChip extends StatelessWidget {
  final Category category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl != null
        ? ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: category.imageUrl!,
          )
        : null;

    return GestureDetector(
      onTap: () {
        context.push(RouteName.categoryScreen, extra: category);
      },
      child: Container(
        width: context.isTablet? 100 : 80,
        margin: EdgeInsets.only(right: AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category image - white background for premium surface
            Container(
              width: context.isTablet? 90 :  70,
              height: context.isTablet?90: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: imageUrl != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: context.isTablet? 76: 56,
                        height: context.isTablet? 76: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.white,
                          child: Icon(
                            Icons.category_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.category_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.category_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
            ),
            SizedBox(height: AppSizes.xs),
            // Category name - max 2 lines, ellipsis if longer
            Expanded(
              child: Text(
                category.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.txtPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
