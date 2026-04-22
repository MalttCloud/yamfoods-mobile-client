import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/constants/api_urls.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/image_url_builder.dart';
import '../../../../../features/order/domain/entities/order_item.dart';

/// Section displaying order items list.
class OrderItemsSection extends ConsumerWidget {
  final List<OrderItem> items;

  const OrderItemsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${items.length})',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.lg),
          ...items.asMap().entries.expand((entry) {
            final index = entry.key;
            final item = entry.value;
            return [
              _OrderItemRow(item: item),
              if (index < items.length - 1)
                Divider(
                  height: AppSizes.lg,
                  thickness: 1,
                  color: AppColors.grey.withValues(alpha: 0.2),
                ),
            ];
          }),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.images.isNotEmpty
        ? ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: item.images.first,
          )
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.grey.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.grey.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.fastfood_outlined,
                      color: AppColors.txtSecondary,
                      size: 24,
                    ),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: AppColors.grey.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.fastfood_outlined,
                    color: AppColors.txtSecondary,
                    size: 24,
                  ),
                ),
        ),
        SizedBox(width: AppSizes.md),
        // Name and details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.description != null && item.description!.isNotEmpty) ...[
                SizedBox(height: AppSizes.xs),
                Text(
                  item.description!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: AppSizes.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.quantity} × ${item.price.toStringAsFixed(2)} ${AppConstants.currency}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary,
                    ),
                  ),
                  Text(
                    '${(item.quantity * item.price).toStringAsFixed(2)} ${AppConstants.currency}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.txtPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
