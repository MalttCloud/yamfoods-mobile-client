import 'package:freezed_annotation/freezed_annotation.dart';
import 'promo_code.dart';

part 'promo_code_verification_result.freezed.dart';

/// Result of verifying a promo code.
@freezed
sealed class PromoCodeVerificationResult with _$PromoCodeVerificationResult {
  const factory PromoCodeVerificationResult({
    required bool isValid,
    required String discount,
    required PromoCode promo,
  }) = _PromoCodeVerificationResult;
}
