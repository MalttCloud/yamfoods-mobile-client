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

/// Confetti colors using app theme.
const List<Color> _confettiColors = [AppColors.primary, AppColors.white];

/// Full-screen order success confirmation shown after payment is verified.
///
/// User must choose one of the two actions; no app bar or back button.
/// [orderId] is passed so "View order" can open that order's detail.
/// Launches confetti from both sides for a short celebration.
class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final int orderId;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: Column(
              children: [
                const Spacer(flex: 3),
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
                const Spacer(flex: 2),
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
                const Spacer(flex: 3),
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
