/// Payment method for checkout.
enum PaymentMethod {
  telebirr,
  chapa,
}

extension PaymentMethodX on PaymentMethod {
  /// Value sent to backend (e.g. "telebirr", "chapa").
  String get value => switch (this) {
        PaymentMethod.telebirr => 'telebirr',
        PaymentMethod.chapa => 'chapa',
      };
}

/// Extension to convert string from API/state to [PaymentMethod].
extension PaymentMethodStringExtension on String {
  PaymentMethod toPaymentMethod() {
    switch (toLowerCase().trim()) {
      case 'telebirr':
        return PaymentMethod.telebirr;
      case 'chapa':
        return PaymentMethod.chapa;
      default:
        return PaymentMethod.telebirr;
    }
  }
}
