import 'package:latlong2/latlong.dart';

import '../../features/map/domain/entities/driver_location.dart';

/// Resolves map icon rotation for the driver marker from location updates.
///
/// - Uses backend [DriverLocation.heading] when present.
/// - Otherwise computes bearing from the previous position ([latlong2]).
/// - Smooths rotation and blocks sudden 180° flips from GPS noise.
/// - Converts travel bearing to [iconRotate] for an asset whose front faces
///   **left** at 0° (Mapbox/Gebeta: 0° = up/north, clockwise).
class DriverMarkerHeading {
  DriverMarkerHeading({
    this.minMoveMeters = 3,
    this.smoothingFactor = 0.25,
    this.maxDegreesPerUpdate = 35,
  });

  /// Ignore bearing updates when movement is below this (reduces GPS jitter).
  final double minMoveMeters;

  /// 0–1 blend toward the new bearing each update (lower = smoother).
  final double smoothingFactor;

  /// Caps how far the icon can turn per location tick (prevents snap flips).
  final double maxDegreesPerUpdate;

  static const Distance _distance = Distance();

  /// PNG faces **left** (west) at `iconRotate: 0`; +90° aligns front with north.
  static const double assetBaselineOffsetDegrees = 90;

  double? _lastLat;
  double? _lastLng;
  double? _smoothedBearingDegrees;

  /// Returns `iconRotate` for [SymbolOptions], or null if rotation is unknown.
  double? update(DriverLocation location) {
    final movedMeters = _movedMetersSinceLast(location);
    final rawBearing = _resolveRawBearing(location, movedMeters);

    _lastLat = location.lat;
    _lastLng = location.lng;

    if (rawBearing == null) {
      return _smoothedBearingDegrees == null
          ? null
          : bearingToIconRotate(_smoothedBearingDegrees!);
    }

    _smoothedBearingDegrees = _advanceSmoothedBearing(
      rawBearing,
      movedMeters: movedMeters,
    );

    return bearingToIconRotate(_smoothedBearingDegrees!);
  }

  void reset() {
    _lastLat = null;
    _lastLng = null;
    _smoothedBearingDegrees = null;
  }

  double _movedMetersSinceLast(DriverLocation location) {
    if (_lastLat == null || _lastLng == null) return 0;
    return _distance(
      LatLng(_lastLat!, _lastLng!),
      LatLng(location.lat, location.lng),
    );
  }

  double? _resolveRawBearing(DriverLocation location, double movedMeters) {
    final backend = location.heading;
    if (backend != null && backend.isFinite) {
      return _normalizeDegrees(backend);
    }

    if (_lastLat == null || _lastLng == null) return null;
    if (movedMeters < minMoveMeters) return null;

    return _normalizeDegrees(
      _distance.bearing(
        LatLng(_lastLat!, _lastLng!),
        LatLng(location.lat, location.lng),
      ),
    );
  }

  double _advanceSmoothedBearing(
    double rawBearing, {
    required double movedMeters,
  }) {
    final previous = _smoothedBearingDegrees;
    if (previous == null) return rawBearing;

    final delta = _shortestDeltaDegrees(previous, rawBearing);

    // GPS spike / reversed segment: ignore near-180° jumps on tiny moves.
    if (delta.abs() > 150 && movedMeters < minMoveMeters * 4) {
      return previous;
    }

    // Real U-turn or sharp corner with meaningful movement: snap bearing.
    if (delta.abs() >= 120 && movedMeters >= 8) {
      return rawBearing;
    }

    final step = (delta * smoothingFactor).clamp(
      -maxDegreesPerUpdate,
      maxDegreesPerUpdate,
    );
    return _normalizeDegrees(previous + step);
  }

  static double bearingToIconRotate(double bearingDegrees) {
    return (_normalizeDegrees(bearingDegrees) + assetBaselineOffsetDegrees) %
        360;
  }

  static double _normalizeDegrees(double degrees) {
    final normalized = degrees % 360;
    return normalized < 0 ? normalized + 360 : normalized;
  }

  /// Signed shortest angle from [from] to [to], in degrees (-180..180].
  static double _shortestDeltaDegrees(double from, double to) {
    return ((to - from + 540) % 360) - 180;
  }
}
