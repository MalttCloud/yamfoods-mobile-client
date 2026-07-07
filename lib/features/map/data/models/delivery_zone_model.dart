import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'delivery_zone_model.freezed.dart';
part 'delivery_zone_model.g.dart';

@freezed
sealed class DeliveryZoneModel with _$DeliveryZoneModel {
  const factory DeliveryZoneModel({
    required String name,
    required List<List<double>> coordinates,
  }) = _DeliveryZoneModel;

  factory DeliveryZoneModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryZoneModelFromJson(json);
}

// 🎯 Extension to map data directly onto flutter_map shapes
extension DeliveryZoneModelX on DeliveryZoneModel {
  List<LatLng> toLatLngPoints() {
    return coordinates.map((point) {
      // Backend sequence: Index 0 = Latitude, Index 1 = Longitude
      final double lat = point[0];
      final double lng = point[1];
      
      // Frontend expects: LatLng(lat, lng)
      return LatLng(lat, lng);
    }).toList();
  }
}
