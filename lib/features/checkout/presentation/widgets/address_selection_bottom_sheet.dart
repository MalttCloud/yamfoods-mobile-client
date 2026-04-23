import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/presentation/providers/address_notifier.dart';
import '../providers/checkout_notifier.dart';

/// Bottom sheet for selecting a delivery address in checkout.
///
/// Shows list of addresses using CheckoutAddressCard with selection indicator.
/// Uses sync value check since "Change" button exists means data is available.
class AddressSelectionBottomSheet extends ConsumerWidget {
  final int branchId;

  const AddressSelectionBottomSheet({super.key, required this.branchId});

  static void show(BuildContext context, int branchId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressSelectionBottomSheet(branchId: branchId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider(branchId));
    final addressAsync = ref.watch(addressProvider);
    final addresses = addressAsync.value ?? [];
    final selectedAddress = checkoutState.selectedAddress;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLg),
          topRight: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: AppSizes.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: Row(
              children: [
                Text(
                  'Select Delivery Address',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.xs),
          // Address list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                final isSelected = selectedAddress?.id == address.id;

                return _SelectableAddressCard(
                  address: address,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(checkoutProvider(branchId).notifier)
                        .selectAddress(address);
                    context.pop();
                  },
                );
              },
            ),
          ),
          // Add Address button
          Padding(
            padding: EdgeInsets.all(AppSizes.sm),
            child: CustomButton(
              text: 'Add New Address',
              width: 200,
              onPressed: () {
                context.pop();
                context.push(RouteName.createOrUpdateAddress);
              },
              height: 44,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Selectable address card with selection indicator.
///
/// Reuses CheckoutAddressCard layout but adds selection indicator.
class _SelectableAddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableAddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.xs),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selection indicator
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: AppColors.white)
                    : null,
              ),
            ),
            SizedBox(width: AppSizes.xs),
            // Address content
            Expanded(
              child: _hasAddress
                  ? Text(
                      address.address,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasAddress =>
      address.address.isNotEmpty && address.address != 'N/A';
}
