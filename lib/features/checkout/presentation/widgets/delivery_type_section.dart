import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/enums/order_type.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../app_configuration/domain/entities/order_type_config.dart';
import '../../../app_configuration/domain/extensions/order_type_config_extensions.dart';
import '../providers/checkout_notifier.dart';

/// Modern segmented control for delivery type selection (Pickup, Delivery, Dining).
/// When Dining is selected, shows a table number field.
class DeliveryTypeSection extends ConsumerStatefulWidget {
  final int branchId;
  final List<OrderTypeConfig> availableOrderTypes;

  const DeliveryTypeSection({super.key, required this.branchId, required this.availableOrderTypes});

  @override
  ConsumerState<DeliveryTypeSection> createState() =>
      _DeliveryTypeSectionState();
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

  String _labelFor(OrderType type) => switch (type) {
        OrderType.dining => 'Dine in',
        _ => type.name,
      };

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider(widget.branchId));
    final orderType = checkoutState.orderType.toOrderType();
    final isDining = orderType == OrderType.dining;
    final orderTypes = widget.availableOrderTypes
        .where((config) => config.isAvailableNow)
        .toList();

    if (orderTypes.isNotEmpty &&
        !orderTypes.any((config) => config.type == orderType)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(checkoutProvider(widget.branchId).notifier)
            .setOrderType(orderTypes.first.type.value);
      });
    }

    if (orderTypes.isEmpty) {
      return const SizedBox.shrink();
    }

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
          LayoutBuilder(
            builder: (context, constraints) {
              const separatorWidth = 1.0;
              final separatorCount =
                  orderTypes.length > 1 ? orderTypes.length - 1 : 0;
              final itemWidth =
                  (constraints.maxWidth - separatorCount * separatorWidth) /
                  orderTypes.length;

              return SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderTypes.length,
                  separatorBuilder: (_, _) => Container(
                    width: separatorWidth,
                    height: 40,
                    color: AppColors.grey.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final config = orderTypes[index];
                    final type = config.type;

                    return SizedBox(
                      width: itemWidth,
                      child: _DeliveryOption(
                        label: _labelFor(type),
                        icon: type.icon,
                        isSelected: orderType == type,
                        onTap: () {
                          ref
                              .read(
                                checkoutProvider(widget.branchId).notifier,
                              )
                              .setOrderType(type.value);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (isDining) ...[
            SizedBox(height: AppSizes.sm),
            InputTextfield(
              controller: _tableNumberController,
              hintText: 'Enter table number',
              icon: Icons.table_restaurant_outlined,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              onChanged: (value) {
                final trimmed = value.trim();
                ref
                    .read(checkoutProvider(widget.branchId).notifier)
                    .setTableNumber(trimmed.isEmpty ? null : trimmed);
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
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.txtSecondary,
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
