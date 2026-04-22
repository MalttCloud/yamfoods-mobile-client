import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';

/// Section displaying QR code for order pickup/delivery verification.
///
/// Only displays if order status is 'ready' or 'outForDelivery'.
class OrderQrSection extends StatelessWidget {
  final String qrCode;

  const OrderQrSection({super.key, required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        children: [
          Text(
            'QR Code for Verification',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            'Show this code to the deliverer',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.txtSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.xl),
          // QR Code
          Container(
            padding: EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radius),
              border: Border.all(
                color: AppColors.grey.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: QrImageView(
              data: qrCode,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: AppColors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          SizedBox(height: AppSizes.md),
          Text(
            qrCode,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.txtSecondary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

