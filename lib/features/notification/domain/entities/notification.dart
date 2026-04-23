import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

@freezed
sealed class Notification with _$Notification {
  const factory Notification({
    required int id,
    required String type, // "user_specific" or "company"
    required String title,
    required String body,
    bool? isRead,
    int? orderId,
    int? productId,
    required DateTime createdAt,
  }) = _Notification;
}
