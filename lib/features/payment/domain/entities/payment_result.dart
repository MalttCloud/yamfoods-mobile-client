import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_result.freezed.dart';

/// Payment result from Telebirr SDK.
///
/// Represents the outcome of a payment attempt:
/// - [PaymentSuccess]: Payment completed successfully (with optional transactionId)
/// - [PaymentFailure]: Payment failed with error message
/// - [PaymentCancelled]: User cancelled the payment
@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult.success({String? transactionId}) = PaymentSuccess;

  const factory PaymentResult.failure({required String message}) =
      PaymentFailure;

  const factory PaymentResult.cancelled() = PaymentCancelled;
}
