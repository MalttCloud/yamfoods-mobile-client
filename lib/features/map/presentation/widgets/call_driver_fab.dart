import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';

/// Floating action button to call the delivery driver.
///
/// Uses url_launcher to initiate a phone call.
/// Only visible when deliverer phone is available.
class CallDriverFab extends StatelessWidget {
  final String? delivererPhone;

  const CallDriverFab({super.key, this.delivererPhone});

  Future<void> _callDriver(BuildContext context) async {
    if (delivererPhone == null || delivererPhone!.isEmpty) {
      _showSnackBar(context, 'Driver phone number not available');
      return;
    }

    final uri = Uri(scheme: 'tel', path: delivererPhone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        _showSnackBar(context, 'Could not launch phone dialer');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Uncomment after testing
    // Hide FAB if no phone number
    // if (delivererPhone == null || delivererPhone!.isEmpty) {
    //   return const SizedBox.shrink();
    // }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _callDriver(context),
        backgroundColor: AppColors.success,
        elevation: 0,
        child: const Icon(Icons.call_rounded, color: AppColors.white, size: 26),
      ),
    );
  }
}
