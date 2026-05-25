import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/map_marker_image.dart';

/// Container for all map marker assets.
///
/// Pre-loads marker images as Uint8List for efficient use with gebeta_gl SDK.
/// This ensures markers are loaded once and cached in memory.
class MapAssets {
  final Uint8List restaurantMarker;
  final Uint8List driverMarker;
  final Uint8List customerMarker;

  const MapAssets({
    required this.restaurantMarker,
    required this.driverMarker,
    required this.customerMarker,
  });
}

/// Provider that loads and caches map marker assets.
///
/// This ensures markers are loaded once and reused throughout the app lifecycle.
/// Assets are loaded as Uint8List for direct use with gebeta_gl SDK.
///
/// Usage:
/// ```dart
/// final assets = await ref.watch(mapAssetsProvider.future);
/// controller.addSymbol(SymbolOptions(
///   iconImage: assets.restaurantMarker, // Uint8List
///   geometry: LatLng(lat, lng),
/// ));
/// ```
final mapAssetsProvider = FutureProvider<MapAssets>((ref) async {
  final restaurantBytes = await rootBundle
      .load('assets/gebeta/markers/restaurant_marker.png')
      .then((data) => data.buffer.asUint8List());

  final driverRaw = await rootBundle
      .load('assets/gebeta/markers/driver_marker.png')
      .then((data) => data.buffer.asUint8List());
  final driverBytes = await resizeMarkerPng(driverRaw, targetWidth: 160);

  final customerBytes = await rootBundle
      .load('assets/gebeta/markers/customer_marker.png')
      .then((data) => data.buffer.asUint8List());

  return MapAssets(
    restaurantMarker: restaurantBytes,
    driverMarker: driverBytes,
    customerMarker: customerBytes,
  );
});
