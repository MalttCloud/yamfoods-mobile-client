import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../features/order/domain/entities/order_detail.dart';
import 'info_row.dart';

/// Section displaying delivery address information.
///
/// Only displays if address is not null (pickup orders have null address).
class OrderAddressSection extends StatelessWidget {
  final OrderDetail orderDetail;

  const OrderAddressSection({super.key, required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    final address = orderDetail.address;
    if (address == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                'Delivery Address',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.txtPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.lg),
          InfoRow(
            label: 'Address',
            value: address.address,
            icon: Icons.location_on,
          ),
          if (address.label != null && address.label!.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            InfoRow(
              label: 'Label',
              value: address.label!,
              icon: Icons.bookmark_outline,
            ),
          ],
          if (address.receiverName != null && address.receiverName!.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            InfoRow(
              label: 'Receiver',
              value: address.receiverName!,
              icon: Icons.person_outline,
            ),
          ],
          if (address.receiverPhone != null && address.receiverPhone!.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            InfoRow(
              label: 'Phone',
              value: address.receiverPhone!,
              icon: Icons.phone_outlined,
            ),
          ],
        ],
      ),
    );
  }
}
