import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_images.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../order/domain/entities/order_payment_query_result.dart';

/// Confetti colors using app theme.
const List<Color> _confettiColors = [AppColors.primary, AppColors.white];

/// Full-screen order success confirmation shown after payment is verified.
///
/// User must choose one of the two actions; no app bar or back button.
/// [orderId] is passed so "View order" can open that order's detail.
/// Launches confetti from both sides for a short celebration.
class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.paymentResult,
  });

  final int orderId;
  final OrderPaymentQueryResult paymentResult;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  static const int _frameTimeMs = 1000 ~/ 24;
  static const Duration _confettiMaxDuration = Duration(seconds: 10);

  Timer? _confettiTimer;
  Timer? _confettiStopTimer;
  ConfettiController? _controller1;
  ConfettiController? _controller2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startConfetti());
  }

  void _startConfetti() {
    if (!mounted) return;
    final ctx = context;

    _confettiTimer = Timer.periodic(
      const Duration(milliseconds: _frameTimeMs),
      (_) {
        if (!mounted) return;

        if (_controller1 == null) {
          _controller1 = Confetti.launch(
            ctx,
            options: const ConfettiOptions(
              particleCount: 2,
              angle: 60,
              spread: 55,
              x: 0,
              colors: _confettiColors,
            ),
          );
        } else {
          _controller1!.launch();
        }

        if (_controller2 == null) {
          _controller2 = Confetti.launch(
            ctx,
            options: const ConfettiOptions(
              particleCount: 2,
              angle: 120,
              spread: 55,
              x: 1,
              colors: _confettiColors,
            ),
          );
        } else {
          _controller2!.launch();
        }
      },
    );

    _confettiStopTimer = Timer(_confettiMaxDuration, _stopConfettiAnimation);
  }

  void _stopConfettiAnimation() {
    _confettiTimer?.cancel();
    _confettiTimer = null;
    _confettiStopTimer?.cancel();
    _confettiStopTimer = null;
    _controller1?.kill();
    _controller2?.kill();
  }

  @override
  void dispose() {
    _stopConfettiAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.xl,
              vertical: AppSizes.lg,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSizes.xl),
                const _SuccessIcon(),
                const SizedBox(height: AppSizes.xxl),
                Text(
                  'Order placed successfully',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.txtPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Thank you for your order. We\'re preparing your food and will notify you when it\'s on its way.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.txtSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.xl),
                _PaymentDetailsCard(paymentResult: widget.paymentResult),
                const SizedBox(height: AppSizes.xxl),
                CustomButton(
                  text: 'View order',
                  onPressed: () => context.pushReplacement(
                    RouteName.orderDetail,
                    extra: widget.orderId,
                  ),
                  icon: Icons.receipt_long_rounded,
                ),
                const SizedBox(height: AppSizes.lg),
                CustomButton(
                  text: 'Continue shopping',
                  onPressed: () => context.go(RouteName.home),
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.btnSecondary,
                  textColor: AppColors.txtPrimary,
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 210,
      child: Image.asset(AppImages.orderSuccessIcon, fit: BoxFit.contain),
    );
  }
}

class _PaymentDetailsCard extends StatelessWidget {
  const _PaymentDetailsCard({required this.paymentResult});

  final OrderPaymentQueryResult paymentResult;

  @override
  Widget build(BuildContext context) {
    final rows = <_PaymentDetailRow>[
      const _PaymentDetailRow(label: 'Status', value: 'Successful'),
      if (paymentResult.method != null)
        _PaymentDetailRow(label: 'Method', value: paymentResult.method!),
      if (paymentResult.amount != null)
        _PaymentDetailRow(
          label: 'Amount',
          value:
              '${paymentResult.amount!.toStringAsFixed(2)} ${AppConstants.currency}',
        ),
      if (paymentResult.transId != null)
        _PaymentDetailRow(label: 'Transaction ID', value: paymentResult.transId!),
      if (paymentResult.transTime != null)
        _PaymentDetailRow(
          label: 'Transaction time',
          value: _displayTransTime(paymentResult.transTime!),
        ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Payment details',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.txtPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSizes.sm),
            rows[i],
          ],
        ],
      ),
    );
  }

  /// Shows API-style `yyyy-MM-dd HH:mm:ss` even when backend sends ISO-8601.
  static String _displayTransTime(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    try {
      final dt = DateTime.parse(trimmed).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
          '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
    } catch (_) {
      return trimmed
          .replaceFirst('T', ' ')
          .replaceAll(RegExp(r'[Zz]\s*$'), '')
          .trim();
    }
  }
}

class _PaymentDetailRow extends StatelessWidget {
  const _PaymentDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
