// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapa_payment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(ChapaPaymentService)
const chapaPaymentServiceProvider = ChapaPaymentServiceProvider._();

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
final class ChapaPaymentServiceProvider
    extends $NotifierProvider<ChapaPaymentService, ChapaPaymentService> {
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
  const ChapaPaymentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapaPaymentServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapaPaymentServiceHash();

  @$internal
  @override
  ChapaPaymentService create() => ChapaPaymentService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapaPaymentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapaPaymentService>(value),
    );
  }
}

String _$chapaPaymentServiceHash() =>
    r'fa2ce3d05c6a2a40585cb1c8886ae7972a59297f';

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

abstract class _$ChapaPaymentService extends $Notifier<ChapaPaymentService> {
  ChapaPaymentService build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChapaPaymentService, ChapaPaymentService>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChapaPaymentService, ChapaPaymentService>,
              ChapaPaymentService,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
