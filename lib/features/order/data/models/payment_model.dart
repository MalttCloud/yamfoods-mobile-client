// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
sealed class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    required int id,
    required int orderId,
    required String method,
    required String status,
    String? transId, // should not be required because the customer will order with his point
    String? telebirrPaymentOrderId,
    @JsonKey(fromJson: parseDouble) required double amount,
    DateTime? transTime,
    String? currency,
    String? chapaTxnRef,
    String? chapaMethod,
    required DateTime date,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

