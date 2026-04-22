import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../features/order/domain/entities/order_detail.dart';
import 'info_row.dart';

/// Section displaying branch information for the order.
class OrderBranchSection extends StatelessWidget {
  final OrderDetail orderDetail;

  const OrderBranchSection({super.key, required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    print('branchzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: ${orderDetail.branch}');
    final branch = orderDetail.branch;
    if (branch == null) {
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
              Icon(Icons.store_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: AppSizes.sm),
              Text(
                'Branch Information',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.txtPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.lg),
          InfoRow(label: 'Name', value: branch.name, icon: Icons.storefront),
          SizedBox(height: AppSizes.sm),
          InfoRow(
            label: 'Phone',
            value: branch.contactPhone,
            icon: Icons.phone_outlined,
          ),
          SizedBox(height: AppSizes.sm),
          InfoRow(
            label: 'Address',
            value: branch.address,
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }
}
