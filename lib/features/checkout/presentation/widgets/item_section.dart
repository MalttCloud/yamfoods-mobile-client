import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../cart/domain/entities/cart.dart';
import 'item_card.dart';

/// Collapsible order items section displaying cart items in checkout.
///
/// Shows a list of cart items with their details.
/// By default, only the first item is visible (collapsed state).
class ItemSection extends StatefulWidget {
  final List<Cart> carts;

  const ItemSection({super.key, required this.carts});

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.carts.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalQuantity = widget.carts.fold<int>(
      0,
      (sum, cart) => sum + cart.quantity,
    );

    // Show only first item when collapsed
    final visibleItems = _isExpanded ? widget.carts : [widget.carts.first];
    final remainingCount = _isExpanded ? 0 : widget.carts.length - 1;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      padding: EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section header with expand/collapse
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.xs,
                vertical: AppSizes.xs / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Summary',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$totalQuantity ${totalQuantity == 1 ? 'item' : 'items'}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.txtSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isExpanded) ...[
                        SizedBox(width: AppSizes.xs),
                        Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.txtSecondary,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.xs),
          // Cart items list
          ...visibleItems.map((cart) => ItemCard(cart: cart)),
          // Show remaining count when collapsed
          if (!_isExpanded && remainingCount > 0)
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: AppSizes.xs / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '+ $remainingCount more ${remainingCount == 1 ? 'item' : 'items'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSizes.xs / 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
