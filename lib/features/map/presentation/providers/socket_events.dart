import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_events.g.dart';

sealed class SocketUiEvent {}

class OrderStatusUpdated extends SocketUiEvent {}

class DriverArrived extends SocketUiEvent {}

/// UI events provider for socket events
///
/// This provider is persistent (keepAlive: true) so events can be emitted
/// even after the SocketEventsNotifier is disposed. This follows the pattern
/// from RIVERPOD_DISPOSE_PATTERN_EXPLANATION.md for handling events that
/// may arrive after navigation.
@Riverpod(keepAlive: true)
class SocketUiEvents extends _$SocketUiEvents {
  @override
  SocketUiEvent? build() {
    return null;
  }

  void emit(SocketUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
