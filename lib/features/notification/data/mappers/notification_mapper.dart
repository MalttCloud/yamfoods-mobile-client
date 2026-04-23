import '../../domain/entities/notification.dart';
import '../models/notification_model.dart';

extension NotificationMapper on NotificationModel {
  Notification toDomain() {
    return Notification(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead,
      orderId: orderId,
      productId: productId,
      createdAt: createdAt,
    );
  }
}
