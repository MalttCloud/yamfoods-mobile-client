// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_address_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deliveryGeofencingService)
const deliveryGeofencingServiceProvider = DeliveryGeofencingServiceProvider._();

final class DeliveryGeofencingServiceProvider
    extends
        $FunctionalProvider<
          DeliveryGeofencingService,
          DeliveryGeofencingService,
          DeliveryGeofencingService
        >
    with $Provider<DeliveryGeofencingService> {
  const DeliveryGeofencingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryGeofencingServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryGeofencingServiceHash();

  @$internal
  @override
  $ProviderElement<DeliveryGeofencingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeliveryGeofencingService create(Ref ref) {
    return deliveryGeofencingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeliveryGeofencingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeliveryGeofencingService>(value),
    );
  }
}

String _$deliveryGeofencingServiceHash() =>
    r'aa91a557d0864eb36c5aa17c7f68cf8369459989';

@ProviderFor(DeliveryAddressSelection)
const deliveryAddressSelectionProvider = DeliveryAddressSelectionProvider._();

final class DeliveryAddressSelectionProvider
    extends
        $NotifierProvider<
          DeliveryAddressSelection,
          DeliveryAddressSelectionState
        > {
  const DeliveryAddressSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryAddressSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryAddressSelectionHash();

  @$internal
  @override
  DeliveryAddressSelection create() => DeliveryAddressSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeliveryAddressSelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeliveryAddressSelectionState>(
        value,
      ),
    );
  }
}

String _$deliveryAddressSelectionHash() =>
    r'ec8c26afc636ed977f1e966121a7ff65ae2999bc';

abstract class _$DeliveryAddressSelection
    extends $Notifier<DeliveryAddressSelectionState> {
  DeliveryAddressSelectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              DeliveryAddressSelectionState,
              DeliveryAddressSelectionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                DeliveryAddressSelectionState,
                DeliveryAddressSelectionState
              >,
              DeliveryAddressSelectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
