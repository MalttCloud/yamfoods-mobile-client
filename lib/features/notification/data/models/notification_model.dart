// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
sealed class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required int id,
    required String type,
    required String title,
    required String body,
    bool? isRead,
    int? orderId,
    int? productId,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
