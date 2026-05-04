class PaymentFeeCalculator {
  const PaymentFeeCalculator._();

  static const double _telebirrRate = 0.005;
  static const double _telebirrThreshold = 30000;
  static const double _telebirrFlatFee = 150;
  static const double _vatRate = 0.15;

  /// Telebirr display fee = facilitation fee + 15% VAT on facilitation fee.
  ///
  /// This is UI-only and should not be used for backend order totals.
  static double telebirrDisplayFee(double amount) {
    if (amount <= 0) return 0.0;

    final facilitationFee = amount <= _telebirrThreshold
        ? amount * _telebirrRate
        : _telebirrFlatFee;
    final vat = facilitationFee * _vatRate;
    return facilitationFee + vat;
  }

  /// Effective fee percent over the given amount.
  static double telebirrDisplayPercent(double amount) {
    if (amount <= 0) return 0.0;
    return (telebirrDisplayFee(amount) / amount) * 100;
  }
}
