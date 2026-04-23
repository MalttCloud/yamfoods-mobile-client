import 'package:latlong2/latlong.dart';

/// Utility class for calculating distances between geographic positions.
class DistanceCalculator {
  /// Singleton instance of Distance for calculating distances.
  static final Distance _distance = Distance();

  /// Calculates the formatted distance between two geographic positions.
  ///
  /// [position1] and [position2] are tuples containing (latitude, longitude).
  ///
  /// Returns the distance as a formatted string:
  /// - If distance < 1000m, returns "Xm" (e.g., "500m")
  /// - If distance >= 1000m, returns "X.Xkm" (e.g., "1.5km")
  ///
  /// Example:
  /// ```dart
  /// final distance = DistanceCalculator.calculateDistanceInMeters(
  ///   (9.011046, 38.761295), // Customer position
  ///   (9.027596658385972, 38.72061392133383), // Branch position
  /// );
  /// print('Distance: $distance'); // "5.2km" or "500m"
  /// ```
  ///
  /// Returns distance in kilometers (km) for storage or API.
  static double distanceInKm(
    ({double lat, double lng}) position1,
    ({double lat, double lng}) position2,
  ) {
    final point1 = LatLng(position1.lat, position1.lng);
    final point2 = LatLng(position2.lat, position2.lng);
    final meters = _distance(point1, point2);
    return meters / 1000;
  }

  static String calculateDistanceInMeters(
    ({double lat, double lng}) position1,
    ({double lat, double lng}) position2,
  ) {
    final meters = (distanceInKm(position1, position2) * 1000).round();

    // Format the distance
    if (meters < 1000) {
      return '${meters}m';
    } else {
      final kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)}km';
    }
  }
}
