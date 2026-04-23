# Driver Location Tracking - Clean Architecture Proposal

## Overview

This document outlines a clean, maintainable, and extensible architecture for implementing real-time driver location tracking using Socket.io and Riverpod.

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Screens    │  │   Widgets    │  │  Providers   │      │
│  │              │  │              │  │  (Stream)    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │   Use Cases  │  │  Interfaces  │      │
│  │              │  │              │  │ (Repository) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Models     │  │  Repository  │  │  Data Source │      │
│  │              │  │  (Impl)      │  │  (Socket)    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                      │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │ Socket Service│ │  Socket Config│                        │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

## Proposed File Structure

```
lib/features/driver_tracking/
├── data/
│   ├── models/
│   │   ├── driver_location_update_model.dart      # Data model from backend
│   │   ├── tracking_room_response_model.dart      # Join tracking response
│   │   └── socket_event_wrapper_model.dart        # Generic socket event wrapper
│   ├── datasources/
│   │   ├── driver_tracking_remote_data_source.dart # Socket.io data source
│   │   └── driver_tracking_remote_data_source_impl.dart
│   └── repositories/
│       ├── driver_tracking_repository.dart         # Repository interface
│       └── driver_tracking_repository_impl.dart   # Repository implementation
│
├── domain/
│   ├── entities/
│   │   ├── driver_location.dart                   # Domain entity
│   │   └── tracking_room_state.dart               # Tracking room state
│   ├── repositories/
│   │   └── driver_tracking_repository.dart         # Repository interface
│   └── usecases/
│       ├── join_tracking_room_usecase.dart
│       └── listen_driver_location_usecase.dart
│
└── presentation/
    ├── providers/
    │   ├── driver_tracking_providers.dart         # DI providers
    │   ├── driver_location_stream_provider.dart   # Stream provider for location
    │   └── tracking_room_state_provider.dart       # State provider
    ├── models/
    │   └── driver_location_ui_model.dart          # UI-specific model
    └── widgets/
        └── driver_marker_widget.dart               # Reusable marker widget
```

## Implementation Details

### 1. Domain Layer - Entities

```dart
// lib/features/driver_tracking/domain/entities/driver_location.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_location.freezed.dart';

@freezed
class DriverLocation with _$DriverLocation {
  const factory DriverLocation({
    required int orderId,
    required double latitude,
    required double longitude,
    required double heading,  // Direction in degrees (0-360)
    required DateTime timestamp,
  }) = _DriverLocation;
}
```

**Why Freezed?**

- Immutability (safe for streams)
- Value equality
- Easy to test
- Built-in copyWith

### 2. Data Layer - Models

```dart
// lib/features/driver_tracking/data/models/driver_location_update_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/driver_location.dart';

part 'driver_location_update_model.freezed.dart';
part 'driver_location_update_model.g.dart';

@freezed
class DriverLocationUpdateModel with _$DriverLocationUpdateModel {
  const factory DriverLocationUpdateModel({
    required int orderId,
    @JsonKey(name: 'lat') required double backendLat,  // Actually longitude
    @JsonKey(name: 'lng') required double backendLng, // Actually latitude
    required double heading,
  }) = _DriverLocationUpdateModel;

  factory DriverLocationUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$DriverLocationUpdateModelFromJson(json);

  /// Converts to domain entity with coordinate swapping
  DriverLocation toEntity() {
    return DriverLocation(
      orderId: orderId,
      latitude: backendLng,  // Swap: backend lng is actual latitude
      longitude: backendLat,  // Swap: backend lat is actual longitude
      heading: heading,
      timestamp: DateTime.now(),
    );
  }
}

/// Wrapper for socket.io response structure
@freezed
class SocketResponseModel<T> with _$SocketResponseModel<T> {
  const factory SocketResponseModel({
    required bool success,
    required T data,
    required Map<String, dynamic> meta,
  }) = _SocketResponseModel;

  factory SocketResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$SocketResponseModelFromJson(json, fromJsonT);
}
```

**Key Points:**

- Coordinate swapping handled in model layer
- Type-safe JSON parsing
- Clear separation between data and domain

### 3. Data Source - Socket.io Integration

```dart
// lib/features/driver_tracking/data/datasources/driver_tracking_remote_data_source.dart
import 'dart:async';
import '../../domain/entities/driver_location.dart';

/// Abstract data source for driver tracking
abstract class DriverTrackingRemoteDataSource {
  /// Stream of driver location updates
  Stream<DriverLocation> get driverLocationStream;

  /// Join tracking room for an order
  Future<void> joinTrackingRoom(int orderId);

  /// Leave tracking room
  Future<void> leaveTrackingRoom(int orderId);

  /// Current connection state
  bool get isConnected;

  /// Dispose resources
  void dispose();
}
```

```dart
// lib/features/driver_tracking/data/datasources/driver_tracking_remote_data_source_impl.dart
import 'dart:async';
import 'package:logger/logger.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../models/driver_location_update_model.dart';
import '../models/socket_response_model.dart';
import '../../domain/entities/driver_location.dart';
import 'driver_tracking_remote_data_source.dart';

class DriverTrackingRemoteDataSourceImpl
    implements DriverTrackingRemoteDataSource {
  final SocketService _socketService;
  final Logger _logger;
  final StreamController<DriverLocation> _locationController =
      StreamController<DriverLocation>.broadcast();

  bool _isListening = false;

  DriverTrackingRemoteDataSourceImpl({
    required SocketService socketService,
    required Logger logger,
  })  : _socketService = socketService,
        _logger = logger {
    _setupLocationListener();
  }

  void _setupLocationListener() {
    if (_isListening) return;

    _socketService.on(
      SocketService.eventDriverLocationUpdated,
      (data) {
        try {
          final response = SocketResponseModel<DriverLocationUpdateModel>.fromJson(
            data as Map<String, dynamic>,
            (json) => DriverLocationUpdateModel.fromJson(
              json as Map<String, dynamic>,
            ),
          );

          if (response.success) {
            final location = response.data.toEntity();
            _locationController.add(location);
            _logger.d('📍 Driver location received: ${location.latitude}, ${location.longitude}');
          }
        } catch (e, stackTrace) {
          _logger.e('Error parsing driver location: $e', error: e, stackTrace: stackTrace);
        }
      },
    );

    _isListening = true;
  }

  @override
  Stream<DriverLocation> get driverLocationStream => _locationController.stream;

  @override
  Future<void> joinTrackingRoom(int orderId) async {
    if (!_socketService.isConnected) {
      throw Exception('Socket not connected');
    }

    _socketService.emit(
      SocketService.eventJoinTracking,
      {'orderId': orderId},
    );

    _logger.i('📡 Joined tracking room for order: $orderId');
  }

  @override
  Future<void> leaveTrackingRoom(int orderId) async {
    // Implementation if backend supports leaving room
    _logger.i('📡 Left tracking room for order: $orderId');
  }

  @override
  bool get isConnected => _socketService.isConnected;

  @override
  void dispose() {
    _socketService.off(SocketService.eventDriverLocationUpdated);
    _locationController.close();
    _isListening = false;
  }
}
```

### 4. Repository Pattern

```dart
// lib/features/driver_tracking/domain/repositories/driver_tracking_repository.dart
import 'dart:async';
import '../entities/driver_location.dart';

abstract class DriverTrackingRepository {
  /// Stream of driver location updates for a specific order
  Stream<DriverLocation> watchDriverLocation(int orderId);

  /// Join tracking room
  Future<Either<Failure, void>> joinTrackingRoom(int orderId);

  /// Leave tracking room
  Future<Either<Failure, void>> leaveTrackingRoom(int orderId);
}
```

```dart
// lib/features/driver_tracking/data/repositories/driver_tracking_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/driver_location.dart';
import '../../domain/repositories/driver_tracking_repository.dart';
import '../datasources/driver_tracking_remote_data_source.dart';

class DriverTrackingRepositoryImpl implements DriverTrackingRepository {
  final DriverTrackingRemoteDataSource _remoteDataSource;

  DriverTrackingRepositoryImpl(this._remoteDataSource);

  @override
  Stream<DriverLocation> watchDriverLocation(int orderId) {
    return _remoteDataSource.driverLocationStream
        .where((location) => location.orderId == orderId);
  }

  @override
  Future<Either<Failure, void>> joinTrackingRoom(int orderId) async {
    try {
      await _remoteDataSource.joinTrackingRoom(orderId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveTrackingRoom(int orderId) async {
    try {
      await _remoteDataSource.leaveTrackingRoom(orderId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }
}
```

### 5. Presentation Layer - Stream Provider

```dart
// lib/features/driver_tracking/presentation/providers/driver_tracking_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/driver_tracking_remote_data_source.dart';
import '../../data/datasources/driver_tracking_remote_data_source_impl.dart';
import '../../data/repositories/driver_tracking_repository_impl.dart';
import '../../domain/repositories/driver_tracking_repository.dart';

part 'driver_tracking_providers.g.dart';

/// Socket service provider (shared across app)
@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) {
  final logger = ref.watch(loggerProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  return SocketService(logger, authLocalDataSource);
}

/// Driver tracking data source provider
@Riverpod(keepAlive: true)
DriverTrackingRemoteDataSource driverTrackingRemoteDataSource(Ref ref) {
  final socketService = ref.watch(socketServiceProvider);
  final logger = ref.watch(loggerProvider);
  return DriverTrackingRemoteDataSourceImpl(
    socketService: socketService,
    logger: logger,
  );
}

/// Driver tracking repository provider
@Riverpod(keepAlive: true)
DriverTrackingRepository driverTrackingRepository(Ref ref) {
  final dataSource = ref.watch(driverTrackingRemoteDataSourceProvider);
  return DriverTrackingRepositoryImpl(dataSource);
}
```

```dart
// lib/features/driver_tracking/presentation/providers/driver_location_stream_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/driver_location.dart';
import '../../domain/repositories/driver_tracking_repository.dart';
import 'driver_tracking_providers.dart';

part 'driver_location_stream_provider.g.dart';

/// Stream provider for driver location updates
///
/// Automatically filters location updates for the specified orderId.
/// Returns AsyncValue<DriverLocation?> - null when no updates received yet.
@riverpod
Stream<DriverLocation?> driverLocationStream(
  DriverLocationStreamRef ref,
  int orderId,
) {
  final repository = ref.watch(driverTrackingRepositoryProvider);

  // Join tracking room when stream is first listened to
  ref.onAdd(() {
    repository.joinTrackingRoom(orderId).then(
      (result) => result.fold(
        (failure) => ref.logger.e('Failed to join tracking room: $failure'),
        (_) => ref.logger.i('✅ Joined tracking room for order: $orderId'),
      ),
    );
  });

  // Leave tracking room when stream is disposed
  ref.onDispose(() {
    repository.leaveTrackingRoom(orderId);
  });

  return repository.watchDriverLocation(orderId);
}
```

### 6. Map Integration - Clean Separation

```dart
// lib/features/map/presentation/providers/driver_marker_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gebeta_gl/gebeta_gl.dart';
import '../../../../features/driver_tracking/presentation/providers/driver_location_stream_provider.dart';
import '../../domain/entities/route.dart';
import 'map_setup_service.dart';

part 'driver_marker_provider.g.dart';

/// Provider that manages driver marker state
@riverpod
class DriverMarker extends _$DriverMarker {
  Symbol? _driverSymbol;

  @override
  Symbol? build() => null;

  /// Initialize driver marker on map setup
  Future<void> initialize({
    required GebetaMapController controller,
    required Route route,
  }) async {
    final setupService = ref.read(mapSetupServiceProvider);
    _driverSymbol = await setupService.createDriverMarker(
      controller: controller,
      initialPosition: route.polyline.first,
    );
    state = _driverSymbol;
  }

  /// Update driver marker position
  Future<void> updatePosition({
    required GebetaMapController controller,
    required double latitude,
    required double longitude,
  }) async {
    if (_driverSymbol == null) {
      // Create marker if it doesn't exist
      final setupService = ref.read(mapSetupServiceProvider);
      _driverSymbol = await setupService.createDriverMarker(
        controller: controller,
        initialPosition: AddressLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      );
      state = _driverSymbol;
    } else {
      // Update existing marker
      await controller.updateSymbol(
        _driverSymbol!,
        SymbolOptions(
          iconImage: 'driver',
          iconSize: 0.25,
          geometry: LatLng(latitude, longitude),
        ),
      );
    }
  }
}
```

### 7. Map Screen Integration

```dart
// lib/features/map/presentation/screens/map_screen.dart (simplified)
class _MapScreenState extends ConsumerState<MapScreen> {
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    final routeAsync = ref.watch(
      routeProvider(widget.restaurantLocation, widget.customerLocation),
    );

    // Watch driver location stream
    final driverLocationAsync = ref.watch(
      driverLocationStreamProvider(widget.orderId),
    );

    return Scaffold(
      body: routeAsync.when(
        data: (route) {
          _currentRoute = route;
          return Stack(
            children: [
              GebetaMap(
                // ... map configuration ...
                onStyleLoadedCallback: _onStyleLoaded,
              ),
              // Handle driver location updates
              driverLocationAsync.when(
                data: (location) {
                  if (location != null && _mapController != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(driverMarkerProvider.notifier).updatePosition(
                        controller: _mapController!,
                        latitude: location.latitude,
                        longitude: location.longitude,
                      );
                    });
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stack) {
                  debugPrint('Driver location error: $error');
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
        // ... rest of route handling ...
      ),
    );
  }
}
```

## Key Design Principles

### 1. **Single Responsibility**

- Each class has one clear purpose
- Data source handles socket communication
- Repository handles business logic
- Providers handle state management

### 2. **Dependency Inversion**

- Domain layer doesn't depend on data layer
- Interfaces in domain, implementations in data
- Easy to test and mock

### 3. **Reactive Programming**

- Stream-based architecture
- Automatic updates when location changes
- No manual state synchronization needed

### 4. **Type Safety**

- Freezed for immutable entities
- Strong typing throughout
- Compile-time error detection

### 5. **Error Handling**

- Either<Failure, T> pattern
- Graceful degradation
- Clear error messages

### 6. **Extensibility**

- Easy to add new socket events
- Separate models for each event type
- Generic socket response wrapper

## Future Extensibility

### Adding New Events

```dart
// 1. Create domain entity
@freezed
class DriverStatusUpdate with _$DriverStatusUpdate {
  const factory DriverStatusUpdate({
    required int orderId,
    required String status,
    required DateTime timestamp,
  }) = _DriverStatusUpdate;
}

// 2. Create data model
@freezed
class DriverStatusUpdateModel with _$DriverStatusUpdateModel {
  // ... model implementation
}

// 3. Add to data source
Stream<DriverStatusUpdate> get driverStatusStream;

// 4. Add to repository
Stream<DriverStatusUpdate> watchDriverStatus(int orderId);

// 5. Create stream provider
@riverpod
Stream<DriverStatusUpdate?> driverStatusStream(
  DriverStatusStreamRef ref,
  int orderId,
) {
  // ... implementation
}
```

## Benefits of This Architecture

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add new features
4. **Type Safety**: Compile-time checks
5. **Reusability**: Components can be reused
6. **Error Handling**: Centralized and consistent
7. **Performance**: Stream-based, efficient updates

## Testing Strategy

```dart
// Example: Testing repository
void main() {
  group('DriverTrackingRepository', () {
    test('should filter location updates by orderId', () async {
      final mockDataSource = MockDriverTrackingRemoteDataSource();
      final repository = DriverTrackingRepositoryImpl(mockDataSource);

      // Test implementation
    });
  });
}
```

## Next Steps

1. Create domain entities
2. Implement data models with coordinate swapping
3. Create data source with socket integration
4. Implement repository
5. Create stream providers
6. Integrate with map screen
7. Add error handling and logging
8. Write unit tests
