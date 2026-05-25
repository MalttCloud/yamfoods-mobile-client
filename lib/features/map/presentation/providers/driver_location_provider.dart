import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/socket/providers/socket_providers.dart';
// import '../../../../core/utils/test_polyline.dart';
import '../../domain/entities/driver_location.dart';

part 'driver_location_provider.g.dart';

/// Stream provider for driver location updates
///
/// Listens to `driver_location_updated` events from Socket.IO and emits
/// [DriverLocation] objects whenever the driver's location changes.
///
/// The provider:
/// - Automatically connects to Socket.IO if not already connected
/// - Joins the tracking room for the specified order
/// - Parses incoming location data into [DriverLocation] model
/// - Handles errors gracefully (logs and continues)
///
/// [orderId] - The order ID to track
@riverpod
Stream<DriverLocation> driverLocation(Ref ref, int orderId) async* {
  final logger = ref.watch(loggerProvider);

  // --- Local test only: replay route from test_polyline.dart (see that file) ---
  // if (kSimulateDriverLocationFromPolyline) {
  //   logger.d(
  //     'Simulating driver location from test polyline (orderId: $orderId)',
  //   );
  //   yield* simulateDriverLocationStream(orderId: orderId);
  //   return;
  // }

  final socketManager = await ref.watch(socketManagerProvider.future);

  // Ensure socket is connected
  if (!socketManager.isConnected) {
    logger.d('Socket not connected, attempting to connect...');
    final connected = await socketManager.connect();
    if (!connected) {
      logger.w(
        'Failed to connect socket for driver tracking (orderId: $orderId)',
      );
      return; // Return empty stream if connection fails
    }
  }

  // Join tracking room
  final joined = socketManager.joinTracking(orderId);
  if (!joined) {
    logger.w('Failed to join tracking room (orderId: $orderId)');
    return; // Return empty stream if join fails
  }

  logger.d('Listening for driver location updates (orderId: $orderId)');

  // Listen to driver_location_updated events
  await for (final data in socketManager.on<Map<String, dynamic>>(
    'driver_location_updated',
  )) {
    try {
      // Parse the incoming data into DriverLocation model
      final location = DriverLocation.fromMap(data);

      // Only emit if this update is for the requested order
      if (location.orderId == orderId) {
        logger.d(
          'Driver location update received: lat=${location.lat}, lng=${location.lng}',
        );
        yield location;
      }
    } catch (e, stackTrace) {
      logger.e(
        'Error parsing driver location data: $e',
        error: e,
        stackTrace: stackTrace,
      );
      // Continue listening even if one update fails to parse
    }
  }
}
