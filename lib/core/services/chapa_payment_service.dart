import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chapasdk/chapasdk.dart';

import '../../features/payment/domain/entities/payment_result.dart';

part 'chapa_payment_service.g.dart';

/// Parameters required to start Chapa native checkout.
///
/// All fields are required by the Chapa SDK for native checkout.
/// Use [ChapaPaymentParams] when calling [ChapaPaymentService.startPayment].
class ChapaPaymentParams {
  const ChapaPaymentParams({
    required this.amount,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.txRef,
    this.title = 'Order Payment',
    this.desc = 'Payment for your order',
    required this.buttonColor,
  });

  /// Amount to charge (string, e.g. "150.50").
  final String amount;

  /// Customer email.
  final String email;

  /// Customer phone (e.g. "0911223344").
  final String phone;

  /// Customer first name.
  final String firstName;

  /// Customer last name.
  final String lastName;

  /// Unique transaction reference (e.g. order id or UUID).
  final String txRef;

  /// Title shown on the payment modal.
  final String title;

  /// Description for the payment.
  final String desc;

  /// Button color for the payment modal.
  final Color buttonColor;
}

/// Converts backend phone variants to local mobile form Chapa expects
/// (`09xxxxxxxx` or `07xxxxxxxx`).
///
/// Handles: `+2519…` / `+2517…`, `09…` / `07…`, and `9…` / `7…` (9 digits).
String _normalizeEthiopianMobileForChapa(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;

  final digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return trimmed;

  if (digits.startsWith('251')) {
    final rest = digits.substring(3);
    if (rest.startsWith('0')) {
      if (rest.length >= 10) return rest.substring(0, 10);
      return rest;
    }
    if (rest.length == 9 && (rest.startsWith('9') || rest.startsWith('7'))) {
      return '0$rest';
    }
  }

  if (digits.length == 10 && digits.startsWith('0')) {
    return digits;
  }

  if (digits.length == 9 &&
      (digits.startsWith('9') || digits.startsWith('7'))) {
    return '0$digits';
  }

  return trimmed;
}

/// Service for handling Chapa payment integration (native checkout only).
///
/// **Configuration:**
/// - Uses [ChapaPaymentService.publicKey] (set from env in production).
/// - Currency: ETB only for native checkout (per Chapa docs).
///
/// **Payment Flow:**
/// 1. Call [startPayment] with [BuildContext] and [ChapaPaymentParams]
/// 2. Chapa SDK shows native payment UI (telebirr, cbebirr, mpesa, ebirr)
/// 3. Result is delivered via [onPaymentFinished]; mapped to [PaymentResult]
///
/// **GoRouter:** Uses empty [namedRouteFallBack] and [onPaymentFinished]
/// so no named route is required.
@riverpod
class ChapaPaymentService extends _$ChapaPaymentService {
  /// Chapa public key. Use test key for testing, live key for production.
  /// Prefer loading from env (e.g. dotenv.env['CHAPA_PUBLIC_KEY']) in app init.
  static final String publicKey = dotenv.env['CHAPA_PUBLIC_KEY']!;

  static const String _currency = 'ETB';

  @override
  ChapaPaymentService build() => ChapaPaymentService();

  /// Starts Chapa native checkout.
  ///
  /// Parameters:
  /// - [context]: BuildContext of the current widget (required by SDK for UI).
  /// - [params]: Payment and customer details.
  ///
  /// Returns:
  /// - [PaymentResult.success] with Chapa transaction reference on success.
  /// - [PaymentResult.failure] with message on failure.
  /// - [PaymentResult.cancelled] if user cancels.
  ///
  /// Native checkout only; web checkout is not used.
  Future<PaymentResult> startPayment(
    BuildContext context,
    ChapaPaymentParams params,
  ) async {
    final completer = Completer<PaymentResult>();

    void completeOnce(PaymentResult result) {
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }

    try {
      Chapa.paymentParameters(
        context: context,
        publicKey: publicKey,
        currency: _currency,
        amount: params.amount,
        email: params.email,
        phone: _normalizeEthiopianMobileForChapa(params.phone),
        firstName: params.firstName,
        lastName: params.lastName,
        txRef: params.txRef,
        title: params.title,
        desc: params.desc,
        nativeCheckout: true,
        namedRouteFallBack: '',
        onPaymentFinished: (String message, String reference, String amount) {
          //print the message, reference, and amount in one line
          if (message == 'paymentSuccessful') {
            completeOnce(PaymentResult.success(transactionId: reference));
          } else if (message == 'paymentCancelled') {
            completeOnce(PaymentResult.cancelled());
          } else {
            completeOnce(PaymentResult.failure(message: message));
          }
        },
      );
      return completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(
          PaymentResult.failure(message: 'Payment error: ${e.toString()}'),
        );
      }
      return completer.future;
    }
  }
}
