import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  completed,
  served,
  cancelled,
  failed,
}

extension OrderStatusX on OrderStatus {
  String get name => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.confirmed => 'Confirmed',
    OrderStatus.preparing => 'Preparing',
    OrderStatus.ready => 'Ready',
    OrderStatus.outForDelivery => 'Out for Delivery',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.completed => 'Completed',
    OrderStatus.served => 'Served',
    OrderStatus.cancelled => 'Cancelled',
    OrderStatus.failed => 'Failed',
  };

  Color get color => switch (this) {
    OrderStatus.pending => Colors.amber,
    OrderStatus.confirmed => Colors.blueGrey,
    OrderStatus.preparing => Colors.orange,
    OrderStatus.ready => Colors.blue,
    OrderStatus.outForDelivery => Colors.indigo,
    OrderStatus.delivered => Colors.green,
    OrderStatus.completed => Colors.green,
    OrderStatus.served => Colors.green,
    OrderStatus.cancelled => Colors.red,
    OrderStatus.failed => Colors.red,
  };

  IconData get icon => switch (this) {
    OrderStatus.pending => Icons.pending_actions,
    OrderStatus.confirmed => Icons.check_circle,
    OrderStatus.preparing => Icons.build,
    OrderStatus.ready => Icons.check_circle,
    OrderStatus.outForDelivery => Icons.local_shipping,
    OrderStatus.delivered => Icons.check_circle,
    OrderStatus.completed => Icons.check_circle,
    OrderStatus.served => Icons.restaurant,
    OrderStatus.cancelled => Icons.cancel,
    OrderStatus.failed => Icons.cancel,
  };

  /// ready: order ready for handover (deliverer not yet started).
  /// delivered: delivery order reached customer.
  /// completed: pickup order collected by customer.
  /// served: dining order received at table.
  String get description => switch (this) {
    OrderStatus.pending => 'Your order is pending confirmation',
    OrderStatus.confirmed => 'Your order has been confirmed',
    OrderStatus.preparing => 'Your order is being prepared',
    OrderStatus.ready => 'Your order is ready for delivery',
    OrderStatus.outForDelivery => 'Your order is out for delivery',
    OrderStatus.delivered => 'Your order has been delivered',
    OrderStatus.completed => 'You have collected your order',
    OrderStatus.served => 'Your order has been served',
    OrderStatus.cancelled => 'Your order has been cancelled',
    OrderStatus.failed => 'Your order has failed',
  };
}

/// Extension to convert string status values from API to [OrderStatus] enum.
extension OrderStatusStringExtension on String {
  /// Converts API status string to [OrderStatus] enum.
  ///
  /// Handles different string formats:
  /// - 'pending' → [OrderStatus.pending]
  /// - 'out_for_delivery' → [OrderStatus.outForDelivery]
  /// - etc.
  OrderStatus toOrderStatus() {
    switch (toLowerCase().replaceAll('_', '')) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'outfordelivery':
      case 'out for delivery':
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'served':
        return OrderStatus.served;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'failed':
        return OrderStatus.failed;
      default:
        return OrderStatus.pending; // Default fallback
    }
  }
}
