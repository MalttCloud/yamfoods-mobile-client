import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_location.freezed.dart';

/// Represents the real-time location of a driver for order tracking.
///
/// This entity is used to receive location updates from the backend
/// via Socket.IO events.
@freezed
sealed class DriverLocation with _$DriverLocation {
  const factory DriverLocation({
    required int orderId,
    required double lat,
    required double lng,
    double? heading, // Optional heading/bearing in degrees (0-360)
  }) = _DriverLocation;

  /// Creates a [DriverLocation] from a Map (typically from Socket.IO event).
  ///
  /// Handles both direct data structure and nested response structure:
  /// - Direct: `{ "orderId": 1, "lat": 38.7, "lng": 8.9, "heading": 57 }`
  /// - Nested: `{ "data": { "orderId": 1, "lat": 38.7, "lng": 8.9, "heading": 57 } }`
  factory DriverLocation.fromMap(Map<String, dynamic> map) {
    // Check if data is nested in a "data" field
    final data = map['data'] as Map<String, dynamic>? ?? map;

    return DriverLocation(
      orderId: data['orderId'] as int,
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      heading: data['heading'] != null
          ? (data['heading'] as num).toDouble()
          : null,
    );
  }
}
