import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/order_type.dart';
import '../../../app_configuration/domain/entities/order_type_config.dart';
import '../../../app_configuration/domain/extensions/order_type_config_extensions.dart';
import '../providers/checkout_notifier.dart';

/// Info note shown when delivery is selected and the API defines service hours.
class DeliveryAvailabilityNote extends ConsumerWidget {
  final int branchId;
  final List<OrderTypeConfig> availableOrderTypes;

  const DeliveryAvailabilityNote({
    super.key,
    required this.branchId,
    required this.availableOrderTypes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider(branchId));

    if (checkoutState.orderType.toOrderType() != OrderType.delivery) {
      return const SizedBox.shrink();
    }

    final deliveryConfig = availableOrderTypes
        .where((config) => config.type == OrderType.delivery)
        .firstOrNull;

    if (deliveryConfig == null) {
      return const SizedBox.shrink();
    }

    final formatTime = MaterialLocalizations.of(context).formatTimeOfDay;
    final message = deliveryConfig.deliveryAvailabilityNote(formatTime);

    if (message == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary.withValues(alpha: 0.9),
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.txtPrimary.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
