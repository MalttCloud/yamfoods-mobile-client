import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class InfoSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.blue,
      duration: duration,
      backgroundColor: AppColors.background,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.info_outline, color: Colors.blue),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
