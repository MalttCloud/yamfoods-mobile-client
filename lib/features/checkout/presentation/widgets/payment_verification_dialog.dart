import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:yamfoods_customer_app/app/components/custom_outlined_button.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_images.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../order/domain/entities/query_order_request.dart';
import '../../../order/domain/entities/order_payment_query_result.dart';
import '../../../order/presentation/providers/order_providers.dart';

/// Dialog shown when verifying payment status after user leaves payment screen.
///
/// Watches [queryOrderProvider] and handles:
/// - **Loading:** "We are processing your payment" with Lottie. Undismissible.
/// - **Data (completed):** Calls [onSuccess], then dismisses.
/// - **Data (failed) / Error:** Shows Retry and Skip buttons. Retry refetches.
///   Skip dismisses without calling [onSuccess].
///
/// **Riverpod refetch and loading:** When Retry calls [ref.invalidate], the provider
/// refetches but [AsyncValue] can keep the previous type (e.g. [AsyncError]) and set
/// [AsyncValue.isLoading] to true during refetch. [.when()] only matches on the
/// *type* (loading/data/error), so it keeps showing the error branch. We show
/// loading whenever [async.isLoading] is true so that refetch shows the loading UI.
///
/// Use [PaymentVerificationDialog.show] to display with correct barrier options.
class PaymentVerificationDialog extends ConsumerStatefulWidget {
  const PaymentVerificationDialog({
    super.key,
    required this.request,
    required this.onSuccess,
  });

  final QueryOrderRequest request;
  final void Function(int orderId) onSuccess;

  /// Shows the payment verification dialog. Undismissible until backend returns.
  static Future<void> show(
    BuildContext context, {
    required QueryOrderRequest request,
    required void Function(int orderId) onSuccess,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          PaymentVerificationDialog(request: request, onSuccess: onSuccess),
    );
  }

  @override
  ConsumerState<PaymentVerificationDialog> createState() =>
      _PaymentVerificationDialogState();
}

class _PaymentVerificationDialogState
    extends ConsumerState<PaymentVerificationDialog> {
  bool _hasHandledSuccess = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(queryOrderProvider(widget.request));

    // Handle success case using ref.listen to avoid duplicate calls
    ref.listen<AsyncValue<OrderPaymentQueryResult>>(
      queryOrderProvider(widget.request),
      (previous, next) {
        if (_hasHandledSuccess) return;

        next.whenData((result) {
          if (result.status == PaymentStatus.completed) {
            _hasHandledSuccess = true;
            // Defer navigation operations until after build phase completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop();
                widget.onSuccess(widget.request.orderId);
              }
            });
          }
        });
      },
    );

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: async.isLoading
            ? _buildLoadingContent(context)
            : async.when(
                data: (result) => _buildResultContent(context, result),
                loading: () => _buildLoadingContent(context),
                error: (error, _) => _buildErrorContent(context),
              ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            // Fixed viewport: we clip a larger Lottie into this area (crop-only).
            height: 190,
            child: ClipRect(
              child: Center(
                child: OverflowBox(
                  alignment: Alignment.center,
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: 330,
                  maxHeight: 330,
                  child: SizedBox(
                    width: 330,
                    height: 330,
                    child: Lottie.asset(
                      AppImages.processPaymentAnime,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'We are processing your payment, Please wait...',
            style: AppTextStyles.h6.copyWith(color: AppColors.txtPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }

  Widget _buildResultContent(
    BuildContext context,
    OrderPaymentQueryResult result,
  ) {
    if (result.status == PaymentStatus.completed) {
      // Keep showing loading so we don't flash white before pop takes effect
      // Navigation is handled in ref.listen above to prevent duplicate calls
      return _buildLoadingContent(context);
    }

    return _buildErrorContent(context);
  }

  Widget _buildErrorContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'assets/images/error/payment_error.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: AppSizes.sm),
          Text(
            'We couldn’t verify your payment. Please try again or use a different payment method. You can also check your order status in order page',
            style: AppTextStyles.buttonLarge.copyWith(
              color: AppColors.txtPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Retry',
                  onPressed: () =>
                      ref.invalidate(queryOrderProvider(widget.request)),
                  icon: Icons.refresh,
                  textColor: AppColors.accentOrange,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Skip',
                  onPressed: () => Navigator.of(context).pop(),
                  textColor: AppColors.txtPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
