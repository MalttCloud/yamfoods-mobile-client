import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/enums/order_type.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../providers/checkout_notifier.dart';

/// Modern segmented control for delivery type selection (Pickup, Delivery, Dining).
/// When Dining is selected, shows a table number field.
class DeliveryTypeSection extends ConsumerStatefulWidget {
  final int branchId;

  const DeliveryTypeSection({super.key, required this.branchId});

  @override
  ConsumerState<DeliveryTypeSection> createState() => _DeliveryTypeSectionState();
}

class _DeliveryTypeSectionState extends ConsumerState<DeliveryTypeSection> {
  late final TextEditingController _tableNumberController;

  @override
  void initState() {
    super.initState();
    _tableNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider(widget.branchId));
    final orderType = checkoutState.orderType.toOrderType();
    final isPickup = orderType == OrderType.pickup;
    final isDelivery = orderType == OrderType.delivery;
    final isDining = orderType == OrderType.dining;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Type',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          // Row with Expanded so each option takes equal horizontal space
          Row(
            children: [
              Expanded(
                child: _DeliveryOption(
                  label: 'Pickup',
                  icon: Icons.store_outlined,
                  isSelected: isPickup,
                  onTap: () {
                    ref
                        .read(checkoutProvider(widget.branchId).notifier)
                        .setOrderType(OrderType.pickup.value);
                  },
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.grey.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _DeliveryOption(
                  label: 'Delivery',
                  icon: Icons.local_shipping_outlined,
                  isSelected: isDelivery,
                  onTap: () {
                    ref
                        .read(checkoutProvider(widget.branchId).notifier)
                        .setOrderType(OrderType.delivery.value);
                  },
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.grey.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _DeliveryOption(
                  label: 'Dine in',
                  icon: Icons.restaurant_outlined,
                  isSelected: isDining,
                  onTap: () {
                    ref
                        .read(checkoutProvider(widget.branchId).notifier)
                        .setOrderType(OrderType.dining.value);
                  },
                ),
              ),
            ],
          ),
          if (isDining) ...[
            SizedBox(height: AppSizes.sm),
            InputTextfield(
              controller: _tableNumberController,
              hintText: 'Enter table number',
              icon: Icons.table_restaurant_outlined,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              onChanged: (value) {
                final trimmed = value.trim();
                ref.read(checkoutProvider(widget.branchId).notifier).setTableNumber(
                      trimmed.isEmpty ? null : trimmed,
                    );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual delivery option button
class _DeliveryOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: AppSizes.xs),
        padding: EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSizes.xs / 2),
            ],
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.txtSecondary,
            ),
            SizedBox(width: AppSizes.xs),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.txtSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
