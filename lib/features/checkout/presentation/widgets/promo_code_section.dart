import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/string_to_double.dart';
import '../../../promocode/presentation/providers/promo_code_notifier.dart';
import '../../../promocode/presentation/providers/promo_code_loading_providers.dart';
import '../../../promocode/presentation/providers/promo_code_events.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_summary_provider.dart';

class PromoCodeSection extends ConsumerStatefulWidget {
  final int branchId;
  const PromoCodeSection({super.key, required this.branchId});

  @override
  ConsumerState<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends ConsumerState<PromoCodeSection> {
  final TextEditingController _promoCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _handleApplyPromoCode() {
    if (_formKey.currentState!.validate()) {
      final code = _promoCodeController.text.trim();

      // Clear any previous error when user tries again
      final currentEvent = ref.read(promoCodeUiEventsProvider);
      if (currentEvent is PromoCodeFailure) {
        ref.read(promoCodeUiEventsProvider.notifier).clear();
      }

      // Get order amount from checkout summary
      final checkoutSummary = ref.read(
        checkoutSummaryProvider(widget.branchId),
      );
      final orderAmount = checkoutSummary.subtotal;

      // Call notifier to verify
      ref.read(promoCodeProvider.notifier).verify(code, orderAmount);
    }
  }

  void _handleRemovePromoCode() {
    _promoCodeController.clear();
    ref.read(checkoutProvider(widget.branchId).notifier).removePromoCode();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to promo code events
    ref.listen<PromoCodeUiEvent?>(promoCodeUiEventsProvider, (prev, next) {
      if (next == null) return;

      if (next is PromoCodeVerified) {
        // Parse discount string to double
        final discount = parseDouble(next.result.discount);
        final code = next.result.promo.code;

        // Update checkout state
        ref
            .read(checkoutProvider(widget.branchId).notifier)
            .setPromoCode(code, discount);
        // Clear the event after success (removes any previous error)
        ref.read(promoCodeUiEventsProvider.notifier).clear();
      }
      // PromoCodeFailure: Don't clear - keep error state until user applies correct code
      // Error is shown in the widget below, no snackbar needed
    });

    final checkoutState = ref.watch(checkoutProvider(widget.branchId));
    final isLoading = ref.watch(promoCodeVerificationLoadingProvider);
    final event = ref.watch(promoCodeUiEventsProvider);
    //final promoCode = ref.watch(promoCodeProvider);

    // If promo code is already applied, show applied state
    final isPromoApplied =
        checkoutState.promoCode != null &&
        checkoutState.promoCodeDiscount != null;

    // Check for error from event
    final hasError = event is PromoCodeFailure;

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
          // Header
          Text(
            'Promo Code',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          // Input field and Apply button
          Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: InputTextfield(
                    controller: _promoCodeController,
                    hintText: 'Enter promo code',
                    icon: Icons.local_offer_outlined,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        return TextEditingValue(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                        );
                      }),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a promo code';
                      }
                      if (value.trim().length < 2 || value.trim().length > 20) {
                        return 'Promo code must be between 2 and 20 characters';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(width: AppSizes.xs),
              // Apply button with loading state
              CustomButton(
                text: 'Apply',
                isLoading: isLoading,
                onPressed: isPromoApplied ? null : _handleApplyPromoCode,
                height: 44,
                width: 100,
              ),
            ],
          ),
          // Show error message
          if (hasError) ...[
            SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: AppColors.error),
                SizedBox(width: AppSizes.xs),
                Expanded(
                  child: Text(
                    'Invalid promo code',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
          // Show applied discount
          if (isPromoApplied) ...[
            SizedBox(height: AppSizes.xs),
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSizes.radius / 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.primary),
                  SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text(
                      'Discount = ${checkoutState.promoCodeDiscount!.toStringAsFixed(2)} ${AppConstants.currency}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _handleRemovePromoCode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.xs),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Remove',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
