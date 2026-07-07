import '../../features/map/data/models/delivery_zone_model.dart';

/// Point-in-polygon checks for delivery zones.
///
/// Zone coordinates use `[lat, lng]` per point (index 0 = latitude).
class DeliveryGeofencingService {
  const DeliveryGeofencingService();

  bool isInsideAnyZone(
    double lat,
    double lng,
    List<DeliveryZoneModel> zones,
  ) {
    for (final zone in zones) {
      if (isPointInPolygon(lat, lng, zone.coordinates)) {
        return true;
      }
    }
    return false;
  }

  bool isPointInPolygon(
    double lat,
    double lng,
    List<List<double>> polygon,
  ) {
    if (polygon.length < 3) return false;

    var inside = false;
    var j = polygon.length - 1;

    for (var i = 0; i < polygon.length; i++) {
      final yi = polygon[i][0];
      final xi = polygon[i][1];
      final yj = polygon[j][0];
      final xj = polygon[j][1];

      final intersects = (yi > lat) != (yj > lat) &&
          lng < (xj - xi) * (lat - yi) / (yj - yi) + xi;

      if (intersects) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}
