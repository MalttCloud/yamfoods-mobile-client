// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Map API service provider
///
/// Provides Retrofit API service for map/direction endpoints.
/// Uses externalApiDioClientProvider since this is an external API (Gebeta Maps)
/// with a different base URL. The baseUrl is specified in the @RestApi annotation
/// and will be used instead of the Dio instance's baseUrl.

@ProviderFor(mapApiService)
const mapApiServiceProvider = MapApiServiceProvider._();

/// Map API service provider
///
/// Provides Retrofit API service for map/direction endpoints.
/// Uses externalApiDioClientProvider since this is an external API (Gebeta Maps)
/// with a different base URL. The baseUrl is specified in the @RestApi annotation
/// and will be used instead of the Dio instance's baseUrl.

final class MapApiServiceProvider
    extends $FunctionalProvider<MapApiService, MapApiService, MapApiService>
    with $Provider<MapApiService> {
  /// Map API service provider
  ///
  /// Provides Retrofit API service for map/direction endpoints.
  /// Uses externalApiDioClientProvider since this is an external API (Gebeta Maps)
  /// with a different base URL. The baseUrl is specified in the @RestApi annotation
  /// and will be used instead of the Dio instance's baseUrl.
  const MapApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapApiServiceHash();

  @$internal
  @override
  $ProviderElement<MapApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapApiService create(Ref ref) {
    return mapApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapApiService>(value),
    );
  }
}

String _$mapApiServiceHash() => r'a18b7cae608d8cdd4fe8533ace75bf1ad8bef185';

/// Map data source provider
///
/// Provides implementation for fetching route data from Gebeta Maps API.

@ProviderFor(mapDataSource)
const mapDataSourceProvider = MapDataSourceProvider._();

/// Map data source provider
///
/// Provides implementation for fetching route data from Gebeta Maps API.

final class MapDataSourceProvider
    extends $FunctionalProvider<MapDataSource, MapDataSource, MapDataSource>
    with $Provider<MapDataSource> {
  /// Map data source provider
  ///
  /// Provides implementation for fetching route data from Gebeta Maps API.
  const MapDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapDataSourceHash();

  @$internal
  @override
  $ProviderElement<MapDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapDataSource create(Ref ref) {
    return mapDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapDataSource>(value),
    );
  }
}

String _$mapDataSourceHash() => r'fc2f9e3f0167760729a361788d15134507004265';

/// Map repository provider
///
/// Provides the main repository for map operations.

@ProviderFor(mapRepository)
const mapRepositoryProvider = MapRepositoryProvider._();

/// Map repository provider
///
/// Provides the main repository for map operations.

final class MapRepositoryProvider
    extends $FunctionalProvider<MapRepository, MapRepository, MapRepository>
    with $Provider<MapRepository> {
  /// Map repository provider
  ///
  /// Provides the main repository for map operations.
  const MapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRepositoryHash();

  @$internal
  @override
  $ProviderElement<MapRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapRepository create(Ref ref) {
    return mapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapRepository>(value),
    );
  }
}

String _$mapRepositoryHash() => r'870f811f6b4397876709e339cf316b4c7615a799';

/// Get route usecase provider
///
/// Provides usecase for fetching route directions between two locations.

@ProviderFor(getRouteUsecase)
const getRouteUsecaseProvider = GetRouteUsecaseProvider._();

/// Get route usecase provider
///
/// Provides usecase for fetching route directions between two locations.

final class GetRouteUsecaseProvider
    extends
        $FunctionalProvider<GetRouteUsecase, GetRouteUsecase, GetRouteUsecase>
    with $Provider<GetRouteUsecase> {
  /// Get route usecase provider
  ///
  /// Provides usecase for fetching route directions between two locations.
  const GetRouteUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRouteUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRouteUsecaseHash();

  @$internal
  @override
  $ProviderElement<GetRouteUsecase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRouteUsecase create(Ref ref) {
    return getRouteUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRouteUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRouteUsecase>(value),
    );
  }
}

String _$getRouteUsecaseHash() => r'b8aa81dde84f90b9579c31f1969fb4b3b503c0c7';

/// Get reverse geocoding usecase provider
///
/// Provides usecase for fetching address information from coordinates.

@ProviderFor(getReverseGeocodingUsecase)
const getReverseGeocodingUsecaseProvider =
    GetReverseGeocodingUsecaseProvider._();

/// Get reverse geocoding usecase provider
///
/// Provides usecase for fetching address information from coordinates.

final class GetReverseGeocodingUsecaseProvider
    extends
        $FunctionalProvider<
          GetReverseGeocodingUsecase,
          GetReverseGeocodingUsecase,
          GetReverseGeocodingUsecase
        >
    with $Provider<GetReverseGeocodingUsecase> {
  /// Get reverse geocoding usecase provider
  ///
  /// Provides usecase for fetching address information from coordinates.
  const GetReverseGeocodingUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getReverseGeocodingUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getReverseGeocodingUsecaseHash();

  @$internal
  @override
  $ProviderElement<GetReverseGeocodingUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetReverseGeocodingUsecase create(Ref ref) {
    return getReverseGeocodingUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetReverseGeocodingUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetReverseGeocodingUsecase>(value),
    );
  }
}

String _$getReverseGeocodingUsecaseHash() =>
    r'92f2cf7203cef6fe3ec691bee3003a6733015889';

/// Get delivery zones usecase provider

@ProviderFor(getDeliveryZonesUsecase)
const getDeliveryZonesUsecaseProvider = GetDeliveryZonesUsecaseProvider._();

/// Get delivery zones usecase provider

final class GetDeliveryZonesUsecaseProvider
    extends
        $FunctionalProvider<
          GetDeliveryZonesUsecase,
          GetDeliveryZonesUsecase,
          GetDeliveryZonesUsecase
        >
    with $Provider<GetDeliveryZonesUsecase> {
  /// Get delivery zones usecase provider
  const GetDeliveryZonesUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDeliveryZonesUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDeliveryZonesUsecaseHash();

  @$internal
  @override
  $ProviderElement<GetDeliveryZonesUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetDeliveryZonesUsecase create(Ref ref) {
    return getDeliveryZonesUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDeliveryZonesUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDeliveryZonesUsecase>(value),
    );
  }
}

String _$getDeliveryZonesUsecaseHash() =>
    r'8c379aa5c0ac4b7ff2f434295856e0f2b4830d99';

/// Search address usecase provider

@ProviderFor(searchAddressUsecase)
const searchAddressUsecaseProvider = SearchAddressUsecaseProvider._();

/// Search address usecase provider

final class SearchAddressUsecaseProvider
    extends
        $FunctionalProvider<
          SearchAddressUsecase,
          SearchAddressUsecase,
          SearchAddressUsecase
        >
    with $Provider<SearchAddressUsecase> {
  /// Search address usecase provider
  const SearchAddressUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchAddressUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchAddressUsecaseHash();

  @$internal
  @override
  $ProviderElement<SearchAddressUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchAddressUsecase create(Ref ref) {
    return searchAddressUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchAddressUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchAddressUsecase>(value),
    );
  }
}

String _$searchAddressUsecaseHash() =>
    r'1cc56669679ace5d6f8cf15864c7f84d73801d12';

/// Route provider
///
/// Fetches route between origin and destination using the usecase.
/// Returns [AsyncValue<Route>] which handles loading, error, and data states.
///
/// [origin] - The starting location
/// [destination] - The target location

@ProviderFor(route)
const routeProvider = RouteFamily._();

/// Route provider
///
/// Fetches route between origin and destination using the usecase.
/// Returns [AsyncValue<Route>] which handles loading, error, and data states.
///
/// [origin] - The starting location
/// [destination] - The target location

final class RouteProvider
    extends $FunctionalProvider<AsyncValue<Route>, Route, FutureOr<Route>>
    with $FutureModifier<Route>, $FutureProvider<Route> {
  /// Route provider
  ///
  /// Fetches route between origin and destination using the usecase.
  /// Returns [AsyncValue<Route>] which handles loading, error, and data states.
  ///
  /// [origin] - The starting location
  /// [destination] - The target location
  const RouteProvider._({
    required RouteFamily super.from,
    required (AddressLocation, AddressLocation) super.argument,
  }) : super(
         retry: null,
         name: r'routeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$routeHash();

  @override
  String toString() {
    return r'routeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Route> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Route> create(Ref ref) {
    final argument = this.argument as (AddressLocation, AddressLocation);
    return route(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RouteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$routeHash() => r'ab3a07953d51bb633fb0d17fc2dc1d15069606e7';

/// Route provider
///
/// Fetches route between origin and destination using the usecase.
/// Returns [AsyncValue<Route>] which handles loading, error, and data states.
///
/// [origin] - The starting location
/// [destination] - The target location

final class RouteFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Route>,
          (AddressLocation, AddressLocation)
        > {
  const RouteFamily._()
    : super(
        retry: null,
        name: r'routeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Route provider
  ///
  /// Fetches route between origin and destination using the usecase.
  /// Returns [AsyncValue<Route>] which handles loading, error, and data states.
  ///
  /// [origin] - The starting location
  /// [destination] - The target location

  RouteProvider call(AddressLocation origin, AddressLocation destination) =>
      RouteProvider._(argument: (origin, destination), from: this);

  @override
  String toString() => r'routeProvider';
}

@ProviderFor(reverseGeocode)
const reverseGeocodeProvider = ReverseGeocodeFamily._();

final class ReverseGeocodeProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const ReverseGeocodeProvider._({
    required ReverseGeocodeFamily super.from,
    required (double, double) super.argument,
  }) : super(
         retry: null,
         name: r'reverseGeocodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reverseGeocodeHash();

  @override
  String toString() {
    return r'reverseGeocodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as (double, double);
    return reverseGeocode(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ReverseGeocodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reverseGeocodeHash() => r'19f022d7f98c86394462c7d14c46b08b9785ca43';

final class ReverseGeocodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, (double, double)> {
  const ReverseGeocodeFamily._()
    : super(
        retry: null,
        name: r'reverseGeocodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReverseGeocodeProvider call(double latitude, double longitude) =>
      ReverseGeocodeProvider._(argument: (latitude, longitude), from: this);

  @override
  String toString() => r'reverseGeocodeProvider';
}

/// Fetches delivery zone polygons for map rendering and geofencing.

@ProviderFor(deliveryZones)
const deliveryZonesProvider = DeliveryZonesProvider._();

/// Fetches delivery zone polygons for map rendering and geofencing.

final class DeliveryZonesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DeliveryZoneModel>>,
          List<DeliveryZoneModel>,
          FutureOr<List<DeliveryZoneModel>>
        >
    with
        $FutureModifier<List<DeliveryZoneModel>>,
        $FutureProvider<List<DeliveryZoneModel>> {
  /// Fetches delivery zone polygons for map rendering and geofencing.
  const DeliveryZonesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryZonesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryZonesHash();

  @$internal
  @override
  $FutureProviderElement<List<DeliveryZoneModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DeliveryZoneModel>> create(Ref ref) {
    return deliveryZones(ref);
  }
}

String _$deliveryZonesHash() => r'c2f29b827ac4c4ca68fd3a5502de5327fe0405d0';

/// Forward geocoding / place autocomplete for address search.

@ProviderFor(addressSearchResults)
const addressSearchResultsProvider = AddressSearchResultsFamily._();

/// Forward geocoding / place autocomplete for address search.

final class AddressSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FGAddressModel>>,
          List<FGAddressModel>,
          FutureOr<List<FGAddressModel>>
        >
    with
        $FutureModifier<List<FGAddressModel>>,
        $FutureProvider<List<FGAddressModel>> {
  /// Forward geocoding / place autocomplete for address search.
  const AddressSearchResultsProvider._({
    required AddressSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'addressSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressSearchResultsHash();

  @override
  String toString() {
    return r'addressSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<FGAddressModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FGAddressModel>> create(Ref ref) {
    final argument = this.argument as String;
    return addressSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressSearchResultsHash() =>
    r'9f603a6f23cd311caef026b77bdfc5ac3fdec525';

/// Forward geocoding / place autocomplete for address search.

final class AddressSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<FGAddressModel>>, String> {
  const AddressSearchResultsFamily._()
    : super(
        retry: null,
        name: r'addressSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Forward geocoding / place autocomplete for address search.

  AddressSearchResultsProvider call(String query) =>
      AddressSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'addressSearchResultsProvider';
}
