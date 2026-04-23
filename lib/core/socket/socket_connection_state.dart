import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_connection_state.freezed.dart';

/// Connection state of the Socket.IO client
///
/// Used to track the current state of the socket connection
/// for UI updates and error handling.
@freezed
sealed class SocketConnectionState with _$SocketConnectionState {
  /// Initial state - socket not yet initialized
  const factory SocketConnectionState.initial() = _Initial;

  /// Connecting to server
  const factory SocketConnectionState.connecting() = _Connecting;

  /// Connected and authenticated
  const factory SocketConnectionState.connected() = _Connected;

  /// Disconnected from server
  const factory SocketConnectionState.disconnected() = _Disconnected;

  /// Connection error occurred
  const factory SocketConnectionState.error({required String message}) = _Error;

  /// Reconnecting after disconnection
  const factory SocketConnectionState.reconnecting({required int attempt}) =
      _Reconnecting;
}
