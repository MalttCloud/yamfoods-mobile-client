import 'failure.dart';

/// Extension on [Failure] to provide user-friendly error messages.
///
/// This extension abstracts technical errors and provides context-aware
/// messages that are safe to display to end users.
extension FailureMapper on Failure {
  /// Returns a user-friendly error message for this [Failure].
  ///
  /// Strategy:
  /// - For backend/auth/validation/payment failures: Trust the backend message
  /// - For network errors: Provide helpful connection guidance
  /// - For permission errors: Context-aware messages based on permission type
  /// - For technical errors (parsing/unexpected): Abstract to friendly messages
  String toUserMessage() {
    return when(
      network: (message) =>
          message ?? 'Please check your internet connection and try again.',
      backend: (message, statusCode) => message,
      auth: (message, statusCode) => message,
      validation: (message) => message,
      permission: (type, permanentlyDenied) {
        switch (type) {
          case PermissionType.location:
            return permanentlyDenied
                ? 'Location access is permanently denied. Please enable it from settings to continue.'
                : 'Location access is required to show nearby branches.';
          case PermissionType.notification:
            return permanentlyDenied
                ? 'Notifications are disabled. Enable them from settings to get order updates.'
                : 'Notifications permission is required to send you order updates.';
          case PermissionType.camera:
            return permanentlyDenied
                ? 'Camera access is permanently denied. Please enable it from settings.'
                : 'Camera access is required to continue.';
          case PermissionType.gallery:
            return permanentlyDenied
                ? 'Gallery access is permanently denied. Please enable it from settings.'
                : 'Gallery access is required to continue.';
        }
      },
      payment: (message) => message,
      cache: (message) =>
          message ?? 'Something went wrong while reading local data.',
      parsing: (message) =>
          message ?? 'We received an unexpected response. Please try again.',
      unexpected: (message) =>
          message ?? 'Something went wrong. Please try again.',
      mapError: (message) => message,
    );
  }
}
