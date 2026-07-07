import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../map/data/models/delivery_zone_model.dart';

class DeliveryZoneMap extends StatefulWidget {
  final List<DeliveryZoneModel> zones;
  final double? selectedLat;
  final double? selectedLng;
  final void Function(double lat, double lng) onMapTap;
  final LatLng? initialCenter;
  final bool showInstructionOverlay;

  const DeliveryZoneMap({
    super.key,
    required this.zones,
    required this.onMapTap,
    this.selectedLat,
    this.selectedLng,
    this.initialCenter,
    this.showInstructionOverlay = true,
  });

  @override
  State<DeliveryZoneMap> createState() => _DeliveryZoneMapState();
}

class _DeliveryZoneMapState extends State<DeliveryZoneMap>
    with TickerProviderStateMixin {
  static const _fallbackCenter = LatLng(9.010491794724187, 38.744469130997395);
  static const _initialZoom = 13.0;
  static const _selectionZoom = 17.0;

  final MapController _mapController = MapController();
  bool _hasInitialCentered = false;
  AnimationController? _moveAnimationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnInitialPosition();
    });
  }

  void _centerOnInitialPosition() {
    final center = widget.initialCenter ?? _mapCenterFromZones();
    _mapController.move(center, _initialZoom);
    // Only lock this in once we've centered on a *real* value (not the
    // zones-based fallback), so that when the current location resolves
    // asynchronously we still get one more chance to re-center on it.
    if (widget.initialCenter != null) {
      _hasInitialCentered = true;
    }
  }

  @override
  void didUpdateWidget(covariant DeliveryZoneMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCenter != null &&
        widget.initialCenter != oldWidget.initialCenter &&
        !_hasInitialCentered) {
      _centerOnInitialPosition();
    }
    if (widget.selectedLat != oldWidget.selectedLat ||
        widget.selectedLng != oldWidget.selectedLng) {
      _moveToSelection();
    }
  }

  void _moveToSelection() {
    if (widget.selectedLat == null || widget.selectedLng == null) return;

    final point = LatLng(widget.selectedLat!, widget.selectedLng!);
    final currentZoom = _mapController.camera.zoom;
    final targetZoom = currentZoom >= _selectionZoom
        ? currentZoom
        : _selectionZoom;

    _animatedMoveTo(point, targetZoom);
  }

  void _animatedMoveTo(LatLng destination, double destZoom) {
    _moveAnimationController?.dispose();
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _moveAnimationController = controller;

    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: destination.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: destination.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    curved.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(curved), lngTween.evaluate(curved)),
        zoomTween.evaluate(curved),
      );
    });

    controller.forward();
  }

  @override
  void dispose() {
    _moveAnimationController?.dispose();
    _mapController.dispose();
    super.dispose();
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

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _mapCenterFromZones(),
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
        ),
        if (widget.showInstructionOverlay)
          Positioned(
            top: 100,
            left: AppSizes.lg,
            right: AppSizes.lg,
            child: Text(
              'Search or tap on the map to select your delivery location',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  LatLng _mapCenterFromZones() {
    if (widget.zones.isNotEmpty) {
      final firstPoint = widget.zones.first.coordinates.first;
      return LatLng(firstPoint[0], firstPoint[1]);
    }
    return _fallbackCenter;
  }
}
