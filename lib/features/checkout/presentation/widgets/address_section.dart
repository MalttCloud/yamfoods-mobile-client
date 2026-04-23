import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/app/components/app_loading_indicator.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/order_type.dart';
import '../../../../core/errors/failure.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/presentation/providers/address_events.dart';
import '../../../address/presentation/providers/address_notifier.dart';
import '../../models/checkout_state.dart';
import '../providers/checkout_notifier.dart';
import 'address_selection_bottom_sheet.dart';
import 'checkout_address_card.dart';

/// Address selection section for checkout.
///
/// Shows address card if address is selected, or "Add Address" button if no addresses.
/// Only visible when order type is "delivery".
/// Auto-selects first address when addresses are available.
class AddressSection extends ConsumerWidget {
  final int branchId;

  const AddressSection({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider(branchId));
    final addressAsync = ref.watch(addressProvider);

    // Listen for address creation events to auto-select new address
    ref.listen<AddressUiEvent?>(addressUiEventsProvider, (prev, next) {
      if (next == null) return;
      if (next is AddressCreated) {
        // Auto-select the newly created address
        ref
            .read(checkoutProvider(branchId).notifier)
            .selectAddress(next.entity);
      }
    });

    // Auto-select first address when delivery is selected and addresses are available
    ref.listen<AsyncValue<List<Address>>>(addressProvider, (prev, next) {
      final currentState = ref.read(checkoutProvider(branchId));
      // Only auto-select if:
      // 1. Delivery is selected
      // 2. Addresses are loaded successfully
      // 3. No address is currently selected
      if (currentState.orderType.toOrderType() == OrderType.delivery &&
          next.hasValue &&
          next.value != null &&
          next.value!.isNotEmpty &&
          currentState.selectedAddress == null) {
        ref
            .read(checkoutProvider(branchId).notifier)
            .selectAddress(next.value!.first);
      }
    });

    // Also react to order type changes (when switching to delivery)
    ref.listen<CheckoutState>(checkoutProvider(branchId), (prev, next) {
      // When switching to delivery, auto-select first address if available
      if (next.orderType.toOrderType() == OrderType.delivery &&
          next.selectedAddress == null &&
          addressAsync.hasValue &&
          addressAsync.value != null &&
          addressAsync.value!.isNotEmpty) {
        ref
            .read(checkoutProvider(branchId).notifier)
            .selectAddress(addressAsync.value!.first);
      }
    });

    // Only show when delivery is selected
    if (checkoutState.orderType.toOrderType() != OrderType.delivery) {
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
            'Delivery Address',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          addressAsync.when(
            data: (addresses) {
              // If no addresses, show add address button
              if (addresses.isEmpty) {
                return CustomButton(
                  text: 'Add Address',
                  onPressed: () => _handleAddAddress(context),
                  height: 44,
                );
              }

              // Show address card with selected address or first address
              final addressToShow =
                  checkoutState.selectedAddress ?? addresses.first;
              return CheckoutAddressCard(
                address: addressToShow,
                onChange: () => _handleAddressChange(context, ref),
              );
            },
            loading: () => AppLoadingIndicator(),
            error: (error, stackTrace) => ErrorWidgett(
              icon: Icons.error_outline,
              title: 'Could not load delivery addresses yet.',
              failure: error is Failure
                  ? error
                  : Failure.unexpected(message: error.toString()),
              onRetry: () => ref.refresh(addressProvider.future),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddressChange(BuildContext context, WidgetRef ref) {
    AddressSelectionBottomSheet.show(context, branchId);
  }

  void _handleAddAddress(BuildContext context) {
    context.push(RouteName.createOrUpdateAddress);
  }
}
