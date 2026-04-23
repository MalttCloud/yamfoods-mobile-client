import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/promo_code_verification_result.dart';
import 'promo_code_providers.dart';
import 'promo_code_events.dart';
import 'promo_code_loading_providers.dart';

part 'promo_code_notifier.g.dart';

/// Manages promo code verification state and operations.
///
/// **State Management:**
/// - Manages verification result state
/// - Emits UI events for success/failure
/// - Tracks loading state for verification
@riverpod
class PromoCodeNotifier extends _$PromoCodeNotifier {
  @override
  PromoCodeVerificationResult? build() {
    return null;
  }

  /// Verifies a promo code with the given order amount.
  ///
  /// Parameters:
  /// - [code]: The promo code to verify
  /// - [orderAmount]: The order amount to validate against
  Future<void> verify(String code, double orderAmount) async {
  // ✅ Store notifiers BEFORE async gap
  final verificationLoading = ref.read(
    promoCodeVerificationLoadingProvider.notifier,
  );
  final eventsNotifier = ref.read(promoCodeUiEventsProvider.notifier);
  
  verificationLoading.setLoading(true);

  try {
    final useCase = await ref.read(verifyPromoCodeUseCaseProvider.future);
    final result = await useCase.call(code: code, orderAmount: orderAmount);

    // ✅ Use stored notifiers (they're still valid even if ref is disposed)
    result.fold(
      (failure) {
        eventsNotifier.emit(PromoCodeFailure(failure));
      },
      (verificationResult) {
        eventsNotifier.emit(PromoCodeVerified(verificationResult, 'Promo code applied successfully'));
      },
    );
  } finally {
    verificationLoading.setLoading(false);
  }
}
}
