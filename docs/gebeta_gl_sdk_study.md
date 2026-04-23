# Gebeta GL SDK Study Guide (v0.22.4)

## Overview

`gebeta_gl` is a Flutter plugin that integrates **MapLibre GL** (vector maps) into Flutter applications. It's based on Mapbox GL but uses Gebeta's tile servers and services.

---

## Core Architecture

### 1. **MapWidget** - The Main Widget

The primary widget that displays the map.

**Key Properties:**

- `initialCameraPosition` - Sets where the map starts (lat/lng + zoom)
- `onMapCreated` - Callback when map is ready (receives MapController)
- `styleString` - Map style (URL, asset path, or JSON string)
- `onMapClick` - Handles tap events on the map
- `myLocationEnabled` - Shows user's current location
- `myLocationTrackingMode` - How to track user location

### 2. **MapController** - Controls the Map Programmatically

Received in `onMapCreated` callback. Used to:

- Move camera to different positions
- Add/remove markers, lines, circles
- Update map style
- Get current camera position
- Animate camera movements

**Key Methods:**

- `animateCamera()` - Smoothly move camera
- `moveCamera()` - Instantly move camera
- `addSymbol()` - Add marker/icon
- `addLine()` - Draw route/polyline
- `addCircle()` - Draw circle
- `removeLayer()` - Remove drawn elements
- `getCameraPosition()` - Get current view

### 3. **CameraPosition** - Defines Map View

Specifies where the map is looking.

```dart
CameraPosition(
  target: LatLng(latitude, longitude),  // Center point
  zoom: 12.0,                           // Zoom level (0-20)
  bearing: 0.0,                        // Rotation (0-360)
  tilt: 0.0,                           // 3D tilt angle
)
```

### 4. **LatLng** - Geographic Coordinates

Represents a point on Earth.

```dart
LatLng(latitude: 9.0192, longitude: 38.7525)
```

---

## Key Features & Capabilities

### 1. **Map Styles**

Three ways to set map style:

**a) Remote URL:**

```dart
styleString: 'https://api.gebeta.app/styles/v1/your-style'
```

**b) Local Asset:**

```dart
styleString: 'asset://assets/gebeta/styles/custom-map-theme.json'
```

**c) Raw JSON String:**

```dart
styleString: jsonString  // Direct JSON
```

**Your Project Has:**

- `assets/gebeta/styles/custom-map-theme.json` - Custom theme
- `assets/gebeta/styles/basic.json` - Basic theme

### 2. **Markers (Symbols)**

Add custom icons/images to the map.

**Your Project Has:**

- `assets/gebeta/markers/marker-start.png` - Origin marker
- `assets/gebeta/markers/marker-current.png` - Current location
- `assets/gebeta/markers/marker-destination.png` - Destination marker

**Usage:**

```dart
controller.addSymbol(
  SymbolOptions(
    geometry: LatLng(lat, lng),
    iconImage: 'asset://assets/gebeta/markers/marker-start.png',
    iconSize: 1.0,
  ),
);
```

### 3. **Routes (Lines/Polylines)**

Draw routes between points.

**Usage:**

```dart
controller.addLine(
  LineOptions(
    geometry: [
      LatLng(lat1, lng1),
      LatLng(lat2, lng2),
      // ... more points
    ],
    lineColor: '#FF0000',
    lineWidth: 5.0,
  ),
);
```

### 4. **Camera Animations**

Smooth transitions between views.

```dart
controller.animateCamera(
  CameraUpdateOptions(
    target: LatLng(newLat, newLng),
    zoom: 15.0,
    duration: Duration(seconds: 2),
  ),
);
```

### 5. **User Location**

Show and track user's location.

```dart
MapWidget(
  myLocationEnabled: true,
  myLocationTrackingMode: MyLocationTrackingMode.Tracking,
)
```

---

## Integration Pattern (How It Works)

### Step 1: Display Map

```dart
MapWidget(
  initialCameraPosition: CameraPosition(
    target: LatLng(9.0192, 38.7525), // Addis Ababa
    zoom: 12.0,
  ),
  styleString: 'asset://assets/gebeta/styles/custom-map-theme.json',
  onMapCreated: (MapController controller) {
    // Store controller for later use
    _mapController = controller;
  },
)
```

### Step 2: Get Route Data

Use your existing `routeProvider` to fetch route from API:

```dart
final routeAsync = ref.watch(routeProvider(
  origin: originLocation,
  destination: destLocation,
));
```

### Step 3: Draw Route on Map

When route data is available:

```dart
routeAsync.whenData((route) {
  // Convert route.polyline (List<AddressLocation>) to List<LatLng>
  final points = route.polyline.map((loc) =>
    LatLng(loc.latitude, loc.longitude)
  ).toList();

  // Draw the route line
  _mapController.addLine(
    LineOptions(
      geometry: points,
      lineColor: '#3B82F6', // Blue route
      lineWidth: 5.0,
    ),
  );

  // Add markers
  _mapController.addSymbol(/* origin marker */);
  _mapController.addSymbol(/* destination marker */);

  // Fit camera to show entire route
  _mapController.animateCamera(/* fit bounds */);
});
```

---

## Important Concepts

### 1. **Layer Management**

- Each element (marker, line, circle) is a "layer"
- Layers have unique IDs
- Remove layers by ID: `controller.removeLayer('layer-id')`
- Layers are drawn in order (last added = on top)

### 2. **Coordinate System**

- Uses **WGS84** (standard GPS coordinates)
- Latitude: -90 to 90 (North/South)
- Longitude: -180 to 180 (East/West)
- Your `AddressLocation` entity already uses this format

### 3. **Zoom Levels**

- 0 = World view
- 5-10 = Country/Region
- 10-15 = City
- 15-20 = Street level
- 20+ = Building level

### 4. **Performance Considerations**

- Limit number of markers (use clustering for many points)
- Simplify polylines for long routes
- Use appropriate zoom levels
- Dispose controllers properly

---

## Best Practices

### 1. **Controller Lifecycle**

```dart
class _MapScreenState extends State<MapScreen> {
  MapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
```

### 2. **Error Handling**

Always handle map loading errors:

```dart
MapWidget(
  onMapError: (error) {
    // Handle error (show message, retry, etc.)
  },
)
```

### 3. **State Management**

- Store `MapController` in StatefulWidget or Riverpod
- Use providers for route data
- Rebuild map only when necessary

### 4. **Memory Management**

- Remove layers when not needed
- Dispose controllers
- Don't keep large route data in memory

---

## Integration with Your Architecture

### Your Existing Setup:

✅ Route API integration (done)
✅ Route model with polyline data (done)
✅ Error handling (done)
✅ Providers for route data (done)

### What You Need to Add:

1. **Map Widget Screen** - Display the map
2. **Map Controller Management** - Handle map interactions
3. **Route Visualization** - Draw route on map
4. **Marker Management** - Show origin/destination
5. **Camera Control** - Fit route in view

---

## Common Use Cases

### 1. **Order Tracking**

- Show delivery route
- Update driver location
- Animate camera to follow driver

### 2. **Address Selection**

- Let user pick location on map
- Show selected location marker
- Reverse geocode to get address

### 3. **Route Preview**

- Show route before confirming order
- Display distance and time
- Allow route alternatives

---

## Next Steps

1. ✅ Understand SDK architecture (this document)
2. ⏭️ Create map widget component
3. ⏭️ Integrate with route provider
4. ⏭️ Add markers and route drawing
5. ⏭️ Implement camera controls
6. ⏭️ Add user interactions

---

## Resources

- **Gebeta Maps Docs:** https://docs.gebeta.app/docs/tiles/flutter
- **MapLibre GL Docs:** https://maplibre.org/maplibre-gl-js-docs/
- **Your Assets:** `assets/gebeta/` folder

---

## Key Takeaways

1. **MapWidget** = The visual map component
2. **MapController** = Programmatic control (add markers, draw routes)
3. **CameraPosition** = Where the map is looking
4. **LatLng** = Geographic coordinates
5. **Layers** = Everything drawn on map (markers, lines, circles)
6. **Style** = Map appearance (use your custom themes)

The SDK is **reactive** - update the controller, map updates automatically.
