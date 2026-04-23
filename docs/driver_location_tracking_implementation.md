# Driver Location Tracking Implementation Documentation

## Overview

This document describes the implementation of real-time driver location tracking on the map screen using Socket.io for receiving location updates and gebeta_gl SDK for map rendering.

## Problem Statement

The customer app needed to display a driver's location on the map that updates in real-time (every 2 seconds) as the driver moves during order delivery. The location data comes from the backend via Socket.io events.

## Architecture Overview

### Components Involved

1. **Backend (Socket.io)**

   - Emits `driver_location_updated` events every 2 seconds
   - Event payload: `{ success: true, data: { orderId, lat, lng, heading }, meta: {...} }`
   - Note: Backend sends coordinates **swapped** (lat=longitude, lng=latitude)

2. **Frontend Components**
   - `MapScreen`: Main screen displaying the map
   - `MapSetupService`: Service for map setup and marker management
   - `SocketService`: Handles Socket.io connection and events

## Implementation Details

### 1. Socket.io Integration

#### SocketService Enhancements

- **Added `emit()` method** to send events to the server
- **Event constants**:
  - `eventJoinTracking = 'join_tracking'`
  - `eventDriverLocationUpdated = 'driver_location_updated'`
  - `eventTrackingJoined = 'tracking_joined'`

#### Connection Flow

1. Initialize socket connection in `MapScreen.initState()`
2. Connect to server with authentication token
3. Listen for `connect:authenticated` event
4. Join tracking room by emitting `join_tracking` with `orderId`
5. Listen for `driver_location_updated` events

### 2. Map Marker Management

#### Initial Marker Creation

- Driver marker is created during map setup in `_onStyleLoaded()`
- Marker is placed at restaurant/route start position initially
- **Important**: Store the `Symbol` reference returned by `addSymbol()` for later updates

#### Marker Update Mechanism

- Use gebeta_gl's `updateSymbol()` method instead of `addSymbol()`
- `addSymbol()` creates new markers (causes duplicates)
- `updateSymbol(symbol, newOptions)` updates existing marker position

### 3. Coordinate Handling

#### Critical Issue: Swapped Coordinates

The backend sends coordinates in reversed format:

- Backend `lat` field = actual **longitude** (38.x)
- Backend `lng` field = actual **latitude** (9.x)

**Solution**: Swap coordinates when parsing:

```dart
final backendLat = responseData['lat'] as double?;  // Actually longitude
final backendLng = responseData['lng'] as double?;  // Actually latitude

// Swap them
final lat = backendLng;  // Correct latitude
final lng = backendLat;  // Correct longitude
```

### 4. Error Handling & Edge Cases

#### Symbol Not Created Yet

- Location updates may arrive before map setup completes
- **Solution**: Fallback method `_createDriverSymbol()` creates symbol on-demand
- Checks if symbol exists before updating, creates if null

#### Null Safety

- Check `_mapController != null` before operations
- Check `_driverSymbol != null` before updating
- Check `mounted` state before setState operations

## File Changes Summary

### Modified Files

#### 1. `lib/core/socket/socket_service.dart`

- Added `emit(String event, dynamic data)` method
- Method logs emitted events for debugging

#### 2. `lib/features/map/presentation/screens/map_screen.dart`

**Added:**

- `orderId` parameter to widget
- `_socketService` instance variable
- `_driverSymbol` to store marker reference
- `_isTrackingJoined` flag

**Methods:**

- `_initializeSocket()`: Sets up socket connection and listeners
- `_joinTrackingRoom()`: Joins tracking room for specific order
- `_handleDriverLocationUpdate()`: Parses and handles location updates
- `_createDriverSymbol()`: Fallback to create symbol if needed

**Key Logic:**

- Coordinate swapping when parsing backend data
- Async handling of location updates
- Symbol creation fallback

#### 3. `lib/features/map/presentation/providers/map_setup_service.dart`

**Modified:**

- `setupMap()`: Now returns `Symbol?` (driver symbol reference)
- `_tryAddMarkers()`: Returns driver symbol reference
- `updateDriverMarkerPosition()`: Uses `updateSymbol()` instead of `addSymbol()`

**Key Changes:**

- Store and return driver symbol from initial creation
- Use `controller.updateSymbol()` for position updates
- Added debug logging

#### 4. `lib/features/map/presentation/models/map_screen_args.dart`

- Added `orderId` field to pass order ID to map screen

#### 5. `lib/features/order/presentation/widgets/detail/order_track_button.dart`

- Pass `orderDetail.order.id` as `orderId` to `MapScreenArgs`

#### 6. `lib/app/routes/app_router.dart`

- Pass `orderId` from `MapScreenArgs` to `MapScreen` widget

## Data Flow

```
Backend Socket.io
    ↓
    Emits: driver_location_updated
    ↓
SocketService.on('driver_location_updated')
    ↓
MapScreen._handleDriverLocationUpdate()
    ↓
Parse & Swap Coordinates
    ↓
Check if _driverSymbol exists
    ↓ (if null)
_createDriverSymbol() OR (if exists)
    ↓
MapSetupService.updateDriverMarkerPosition()
    ↓
controller.updateSymbol(driverSymbol, newOptions)
    ↓
Marker position updated on map
```

## Key Learnings & Best Practices

### 1. Symbol Management

- **Always store symbol references** returned from `addSymbol()`
- **Use `updateSymbol()`** for position updates, not `addSymbol()`
- **Handle null symbols** with fallback creation

### 2. Coordinate Systems

- **Verify coordinate format** from backend
- **Document coordinate swapping** if backend sends reversed data
- **Add validation** for coordinate ranges (e.g., Ethiopia: lat 8-9, lng 38-39)

### 3. Async Operations

- **Handle async socket listeners** properly (use `.catchError()`)
- **Check widget mounted state** before setState
- **Use await** for symbol creation/updates

### 4. Error Handling

- **Add debug logging** at key points
- **Handle null cases** gracefully
- **Provide fallback mechanisms** (e.g., create symbol if missing)

### 5. Lifecycle Management

- **Clean up socket listeners** in `dispose()`
- **Disconnect socket** when screen is disposed
- **Check mounted state** before async operations

## Issues Encountered & Solutions

### Issue 1: Duplicate Markers

**Problem**: Using `addSymbol()` for updates created multiple markers
**Solution**: Store symbol reference and use `updateSymbol()`

### Issue 2: Symbol is Null

**Problem**: Location updates arrived before map setup completed
**Solution**: Added fallback `_createDriverSymbol()` method

### Issue 3: Coordinates Swapped

**Problem**: Backend sends lat/lng reversed
**Solution**: Swap coordinates when parsing backend response

### Issue 4: Marker Not Visible

**Problem**: Coordinates were wrong, marker off-screen
**Solution**: Fixed coordinate swapping

## Testing Checklist

- [ ] Socket connection establishes successfully
- [ ] Tracking room join succeeds
- [ ] Location updates are received every 2 seconds
- [ ] Coordinates are correctly parsed and swapped
- [ ] Driver marker appears at correct initial position
- [ ] Marker updates position smoothly on location changes
- [ ] No duplicate markers created
- [ ] Symbol created on-demand if updates arrive early
- [ ] Cleanup works properly on screen dispose

## Future Improvements

1. **Better Architecture**

   - Separate socket management into dedicated service/provider
   - Create dedicated driver location state management
   - Use Riverpod providers for socket state

2. **Error Recovery**

   - Retry mechanism for failed updates
   - Reconnection handling for socket disconnects
   - Queue location updates if map not ready

3. **Performance**

   - Throttle updates if too frequent
   - Smooth animation for marker movement
   - Camera following driver (optional)

4. **Code Organization**

   - Extract coordinate parsing logic
   - Create dedicated driver marker manager
   - Separate socket event handlers

5. **Testing**
   - Unit tests for coordinate swapping
   - Integration tests for socket flow
   - Widget tests for map screen

## Notes for Refactoring

When rebuilding with clean architecture:

1. **Create separate providers/services:**

   - `DriverLocationProvider`: Manages driver location state
   - `SocketTrackingProvider`: Handles socket tracking logic
   - `MapMarkerService`: Manages map markers (driver, restaurant, customer)

2. **Coordinate handling:**

   - Create `CoordinateParser` utility class
   - Document coordinate format expectations
   - Add validation for coordinate ranges

3. **Error handling:**

   - Use Result/Either pattern for error handling
   - Create custom exceptions for map errors
   - Add retry mechanisms

4. **State management:**
   - Use Riverpod providers for all state
   - Separate UI state from business logic
   - Use freezed for immutable state classes
