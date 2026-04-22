import 'order.dart';

/// Extension on [Orderr] providing convenience methods.
extension OrderExtensions on Orderr {
  /// Returns true if all tracking coordinates (branch + delivery lat/lng) are non-null.
  /// Use this to decide if order tracking can be shown.
  bool get hasValidTrackingCoordinates =>
      branchLocation.lat != null &&
      branchLocation.lng != null &&
      deliveryLocation.lat != null &&
      deliveryLocation.lng != null;
}
