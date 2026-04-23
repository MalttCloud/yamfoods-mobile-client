import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../errors/failure.dart';
import '../errors/failure_mapper.dart';

class ErrorSnackBar {
  static void show(BuildContext context, {required Failure failure}) {
    // Map any Failure to a user-friendly message using the central mapper.
    final message = failure.toUserMessage();

    Flushbar(
      message: message,
      //title: code != null ? 'Error: $code' : null,
      messageColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.background,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
