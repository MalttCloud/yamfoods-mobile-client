import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class SuccessSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      titleColor: AppColors.primary,
      messageColor: AppColors.primary,
      message: message,
      duration: duration,
      backgroundColor: AppColors.background,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.verified_outlined, color: AppColors.primary),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
