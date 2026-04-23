/// Centralized FCM `data` keys used by the app.
///
/// Keep keys stable to avoid breaking old notifications or backend payloads.
/// Keys match backend format (camelCase).
class NotificationPayloadKeys {
  static const String orderId = 'orderId';
  static const String productId = 'productId';

  NotificationPayloadKeys._();
}
