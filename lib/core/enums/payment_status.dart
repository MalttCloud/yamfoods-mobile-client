import 'package:flutter/material.dart';

enum PaymentStatus { pending, completed, failed }

extension PaymentStatusX on PaymentStatus {
  String get name => switch (this) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.completed => 'Completed',
    PaymentStatus.failed => 'Failed',
  };

  Color get color => switch (this) {
    PaymentStatus.pending => Colors.amber,
    PaymentStatus.completed => Colors.green,
    PaymentStatus.failed => Colors.red,
  };

  IconData get icon => switch (this) {
    PaymentStatus.pending => Icons.pending_actions,
    PaymentStatus.completed => Icons.check_circle,
    PaymentStatus.failed => Icons.cancel,
  };

  String get description => switch (this) {
    PaymentStatus.pending => 'Your payment is pending',
    PaymentStatus.completed => 'Your payment has been completed',
    PaymentStatus.failed => 'Your payment has failed',
  };
}

/// Extension to convert string status values from API to [PaymentStatus] enum.
extension PaymentStatusStringExtension on String {
  /// Converts API status string to [PaymentStatus] enum.
  ///
  /// Handles different string formats:
  /// - 'Pending' → [PaymentStatus.pending]
  /// - 'Completed' → [PaymentStatus.completed]
  /// - 'Failed' → [PaymentStatus.failed]
  PaymentStatus toPaymentStatus() {
    switch (toLowerCase().trim()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending; // Default fallback
    }
  }
}
