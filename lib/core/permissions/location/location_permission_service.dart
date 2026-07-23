import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling all location permission and GPS-related operations.
///
/// Provides static methods to check permission status, GPS status, and open settings.
/// Uses both `permission_handler` and `geolocator` packages.
class LocationPermissionService {
  LocationPermissionService._();

  /// Checks the current location permission status.
  ///
  /// Returns the permission status (granted, denied, permanentlyDenied, etc.)
  static Future<PermissionStatus> checkPermissionStatus() async {
    return await Permission.locationWhenInUse.status;
  }

  /// Checks if GPS/High Accuracy location service is enabled.
  ///
  /// Returns `true` if GPS is enabled, `false` otherwise.
  static Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Requests location permission.
  ///
  /// Returns the new permission status after request.
  static Future<PermissionStatus> requestPermission() async {
    return await Permission.locationWhenInUse.request();
  }

  /// Requests current location (triggers GPS accuracy dialog if GPS is disabled).
  ///
  /// When GPS is on, returns the last known cached position when available for a
  /// fast response, otherwise requests a fresh fix. When GPS is off, requests a
  /// high-accuracy fix which triggers Android's "Location Accuracy" system dialog.
  ///
  /// Returns the current position if successful.
  /// Throws an exception if permission is denied or location cannot be determined.
  static Future<Position> requestCurrentLocation() async {
    final permission = await checkPermissionStatus();
    if (!permission.isGranted) {
      throw Exception('Location permission is not granted');
    }

    final gpsEnabled = await isGpsEnabled();
    if (gpsEnabled) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;

      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Checks if location permission is permanently denied.
  ///
  /// Returns `true` if permission is permanently denied (user must go to settings).
  static Future<bool> isPermanentlyDenied() async {
    final status = await checkPermissionStatus();
    return status.isPermanentlyDenied;
  }

  /// Checks if Android should show request rationale.
  ///
  /// Returns `true` if user has denied before but not permanently (can ask again).
  /// This is Android-specific and helps determine if we should request permission again.
  static Future<bool> shouldShowRequestRationale() async {
    return await Permission.locationWhenInUse.shouldShowRequestRationale;
  }
}
