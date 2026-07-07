import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../map/data/models/delivery_zone_model.dart';

class DeliveryZoneMap extends StatefulWidget {
  final List<DeliveryZoneModel> zones;
  final double? selectedLat;
  final double? selectedLng;
  final void Function(double lat, double lng) onMapTap;

  const DeliveryZoneMap({
    super.key,
    required this.zones,
    required this.onMapTap,
    this.selectedLat,
    this.selectedLng,
  });

  @override
  State<DeliveryZoneMap> createState() => _DeliveryZoneMapState();
}

class _DeliveryZoneMapState extends State<DeliveryZoneMap> {
  static const _initialCenter = LatLng(8.985, 38.765);
  static const _initialZoom = 13.0;

  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant DeliveryZoneMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLat != oldWidget.selectedLat ||
        widget.selectedLng != oldWidget.selectedLng) {
      _moveToSelection();
    }
  }

  void _moveToSelection() {
    if (widget.selectedLat == null || widget.selectedLng == null) return;
    _mapController.move(
      LatLng(widget.selectedLat!, widget.selectedLng!),
      _mapController.camera.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final polygons = widget.zones
        .map(
          (zone) => Polygon(
            points: zone.toLatLngPoints(),
            color: AppColors.primary.withValues(alpha: 0.15),
            borderColor: AppColors.primary,
            borderStrokeWidth: 2,
          ),
        )
        .toList();

    final markers = <Marker>[];
    if (widget.selectedLat != null && widget.selectedLng != null) {
      markers.add(
        Marker(
          point: LatLng(widget.selectedLat!, widget.selectedLng!),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on_rounded,
            color: AppColors.primary,
            size: 40,
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _mapCenter(),
        initialZoom: _initialZoom,
        onTap: (_, point) =>
            widget.onMapTap(point.latitude, point.longitude),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.yamfoods.customer',
        ),
        if (polygons.isNotEmpty) PolygonLayer(polygons: polygons),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }

  LatLng _mapCenter() {
    if (widget.selectedLat != null && widget.selectedLng != null) {
      return LatLng(widget.selectedLat!, widget.selectedLng!);
    }

    if (widget.zones.isNotEmpty) {
      final firstPoint = widget.zones.first.coordinates.first;
      return LatLng(firstPoint[0], firstPoint[1]);
    }

    return _initialCenter;
  }
}
