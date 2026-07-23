// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Info API service provider
///
/// Uses dioClientProvider (with auth interceptor) so we can send Authorization
/// header when available (and support protected endpoints like feedback).

@ProviderFor(infoApiService)
const infoApiServiceProvider = InfoApiServiceProvider._();

/// Info API service provider
///
/// Uses dioClientProvider (with auth interceptor) so we can send Authorization
/// header when available (and support protected endpoints like feedback).

final class InfoApiServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<InfoApiService>,
          InfoApiService,
          FutureOr<InfoApiService>
        >
    with $FutureModifier<InfoApiService>, $FutureProvider<InfoApiService> {
  /// Info API service provider
  ///
  /// Uses dioClientProvider (with auth interceptor) so we can send Authorization
  /// header when available (and support protected endpoints like feedback).
  const InfoApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoApiServiceHash();

  @$internal
  @override
  $FutureProviderElement<InfoApiService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InfoApiService> create(Ref ref) {
    return infoApiService(ref);
  }
}

String _$infoApiServiceHash() => r'266227eb36f580f75e398175dce87dc1dbfbcc12';

/// Info remote data source provider

@ProviderFor(infoRemoteDataSource)
const infoRemoteDataSourceProvider = InfoRemoteDataSourceProvider._();

/// Info remote data source provider

final class InfoRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<InfoRemoteDataSource>,
          InfoRemoteDataSource,
          FutureOr<InfoRemoteDataSource>
        >
    with
        $FutureModifier<InfoRemoteDataSource>,
        $FutureProvider<InfoRemoteDataSource> {
  /// Info remote data source provider
  const InfoRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoRemoteDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<InfoRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InfoRemoteDataSource> create(Ref ref) {
    return infoRemoteDataSource(ref);
  }
}

String _$infoRemoteDataSourceHash() =>
    r'94aff50220f4c0807bfe681ae114ce2f96cb3d9b';

/// Info repository provider

@ProviderFor(infoRepository)
const infoRepositoryProvider = InfoRepositoryProvider._();

/// Info repository provider

final class InfoRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<InfoRepository>,
          InfoRepository,
          FutureOr<InfoRepository>
        >
    with $FutureModifier<InfoRepository>, $FutureProvider<InfoRepository> {
  /// Info repository provider
  const InfoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<InfoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InfoRepository> create(Ref ref) {
    return infoRepository(ref);
  }
}

String _$infoRepositoryHash() => r'6919a71b21e915b5863567a2dc85058cc0529ff2';

/// Get help support usecase provider

@ProviderFor(getHelpSupportUsecase)
const getHelpSupportUsecaseProvider = GetHelpSupportUsecaseProvider._();

/// Get help support usecase provider

final class GetHelpSupportUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetHelpSupportUsecase>,
          GetHelpSupportUsecase,
          FutureOr<GetHelpSupportUsecase>
        >
    with
        $FutureModifier<GetHelpSupportUsecase>,
        $FutureProvider<GetHelpSupportUsecase> {
  /// Get help support usecase provider
  const GetHelpSupportUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getHelpSupportUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getHelpSupportUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<GetHelpSupportUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetHelpSupportUsecase> create(Ref ref) {
    return getHelpSupportUsecase(ref);
  }
}

String _$getHelpSupportUsecaseHash() =>
    r'256ba0eb302ac48a889e85221d846156e25a4ea0';

/// Get FAQs usecase provider

@ProviderFor(getFaqsUsecase)
const getFaqsUsecaseProvider = GetFaqsUsecaseProvider._();

/// Get FAQs usecase provider

final class GetFaqsUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetFaqsUsecase>,
          GetFaqsUsecase,
          FutureOr<GetFaqsUsecase>
        >
    with $FutureModifier<GetFaqsUsecase>, $FutureProvider<GetFaqsUsecase> {
  /// Get FAQs usecase provider
  const GetFaqsUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFaqsUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFaqsUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<GetFaqsUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetFaqsUsecase> create(Ref ref) {
    return getFaqsUsecase(ref);
  }
}

String _$getFaqsUsecaseHash() => r'ddb32850f998f5046108ffdf30dd8f1f62892979';

/// Get terms and conditions usecase provider

@ProviderFor(getTermsAndConditionsUsecase)
const getTermsAndConditionsUsecaseProvider =
    GetTermsAndConditionsUsecaseProvider._();

/// Get terms and conditions usecase provider

final class GetTermsAndConditionsUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetTermsAndConditionsUsecase>,
          GetTermsAndConditionsUsecase,
          FutureOr<GetTermsAndConditionsUsecase>
        >
    with
        $FutureModifier<GetTermsAndConditionsUsecase>,
        $FutureProvider<GetTermsAndConditionsUsecase> {
  /// Get terms and conditions usecase provider
  const GetTermsAndConditionsUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTermsAndConditionsUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTermsAndConditionsUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<GetTermsAndConditionsUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetTermsAndConditionsUsecase> create(Ref ref) {
    return getTermsAndConditionsUsecase(ref);
  }
}

String _$getTermsAndConditionsUsecaseHash() =>
    r'abda03641285d4fd7afe01ae62badcb9e7764cba';

/// Get privacy policy usecase provider

@ProviderFor(getPrivacyPolicyUsecase)
const getPrivacyPolicyUsecaseProvider = GetPrivacyPolicyUsecaseProvider._();

/// Get privacy policy usecase provider

final class GetPrivacyPolicyUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetPrivacyPolicyUsecase>,
          GetPrivacyPolicyUsecase,
          FutureOr<GetPrivacyPolicyUsecase>
        >
    with
        $FutureModifier<GetPrivacyPolicyUsecase>,
        $FutureProvider<GetPrivacyPolicyUsecase> {
  /// Get privacy policy usecase provider
  const GetPrivacyPolicyUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPrivacyPolicyUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPrivacyPolicyUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<GetPrivacyPolicyUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetPrivacyPolicyUsecase> create(Ref ref) {
    return getPrivacyPolicyUsecase(ref);
  }
}

String _$getPrivacyPolicyUsecaseHash() =>
    r'f43b37d856bcf99576e6e4a6470683c854525eda';

/// Submit feedback usecase provider

@ProviderFor(submitFeedbackUsecase)
const submitFeedbackUsecaseProvider = SubmitFeedbackUsecaseProvider._();

/// Submit feedback usecase provider

final class SubmitFeedbackUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubmitFeedbackUsecase>,
          SubmitFeedbackUsecase,
          FutureOr<SubmitFeedbackUsecase>
        >
    with
        $FutureModifier<SubmitFeedbackUsecase>,
        $FutureProvider<SubmitFeedbackUsecase> {
  /// Submit feedback usecase provider
  const SubmitFeedbackUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitFeedbackUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitFeedbackUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<SubmitFeedbackUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubmitFeedbackUsecase> create(Ref ref) {
    return submitFeedbackUsecase(ref);
  }
}

String _$submitFeedbackUsecaseHash() =>
    r'174d76553667159d585dcb2776a6b80c924145aa';

/// Submit collaboration request usecase provider

@ProviderFor(submitCollaborationRequestUsecase)
const submitCollaborationRequestUsecaseProvider =
    SubmitCollaborationRequestUsecaseProvider._();

/// Submit collaboration request usecase provider

final class SubmitCollaborationRequestUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubmitCollaborationRequestUsecase>,
          SubmitCollaborationRequestUsecase,
          FutureOr<SubmitCollaborationRequestUsecase>
        >
    with
        $FutureModifier<SubmitCollaborationRequestUsecase>,
        $FutureProvider<SubmitCollaborationRequestUsecase> {
  /// Submit collaboration request usecase provider
  const SubmitCollaborationRequestUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitCollaborationRequestUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$submitCollaborationRequestUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<SubmitCollaborationRequestUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubmitCollaborationRequestUsecase> create(Ref ref) {
    return submitCollaborationRequestUsecase(ref);
  }
}

String _$submitCollaborationRequestUsecaseHash() =>
    r'e5eca61c07ff468d73b65a2f6a761668fb681995';

/// Record DAU usecase provider

@ProviderFor(recordDauUsecase)
const recordDauUsecaseProvider = RecordDauUsecaseProvider._();

/// Record DAU usecase provider

final class RecordDauUsecaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecordDauUsecase>,
          RecordDauUsecase,
          FutureOr<RecordDauUsecase>
        >
    with $FutureModifier<RecordDauUsecase>, $FutureProvider<RecordDauUsecase> {
  /// Record DAU usecase provider
  const RecordDauUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordDauUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordDauUsecaseHash();

  @$internal
  @override
  $FutureProviderElement<RecordDauUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RecordDauUsecase> create(Ref ref) {
    return recordDauUsecase(ref);
  }
}

String _$recordDauUsecaseHash() => r'dde84da4f001857f9f548300d9752c9bced762e8';

/// Help support provider
///
/// Fetches help & support information using the usecase.
/// Returns [AsyncValue<HelpSupport>] which handles loading, error, and data states.

@ProviderFor(helpSupport)
const helpSupportProvider = HelpSupportProvider._();

/// Help support provider
///
/// Fetches help & support information using the usecase.
/// Returns [AsyncValue<HelpSupport>] which handles loading, error, and data states.

final class HelpSupportProvider
    extends
        $FunctionalProvider<
          AsyncValue<HelpSupport>,
          HelpSupport,
          FutureOr<HelpSupport>
        >
    with $FutureModifier<HelpSupport>, $FutureProvider<HelpSupport> {
  /// Help support provider
  ///
  /// Fetches help & support information using the usecase.
  /// Returns [AsyncValue<HelpSupport>] which handles loading, error, and data states.
  const HelpSupportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpSupportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helpSupportHash();

  @$internal
  @override
  $FutureProviderElement<HelpSupport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HelpSupport> create(Ref ref) {
    return helpSupport(ref);
  }
}

String _$helpSupportHash() => r'3904444724547770e8bb44fbecabea0078ad84f8';

/// FAQs list provider
///
/// Fetches all FAQs using the usecase.
/// Returns [AsyncValue<List<Faq>>] which handles loading, error, and data states.

@ProviderFor(faqs)
const faqsProvider = FaqsProvider._();

/// FAQs list provider
///
/// Fetches all FAQs using the usecase.
/// Returns [AsyncValue<List<Faq>>] which handles loading, error, and data states.

final class FaqsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Faq>>,
          List<Faq>,
          FutureOr<List<Faq>>
        >
    with $FutureModifier<List<Faq>>, $FutureProvider<List<Faq>> {
  /// FAQs list provider
  ///
  /// Fetches all FAQs using the usecase.
  /// Returns [AsyncValue<List<Faq>>] which handles loading, error, and data states.
  const FaqsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faqsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faqsHash();

  @$internal
  @override
  $FutureProviderElement<List<Faq>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Faq>> create(Ref ref) {
    return faqs(ref);
  }
}

String _$faqsHash() => r'4eb1e48cdf4de171af86f47c557cd43e8c8be62f';

/// Terms and conditions list provider
///
/// Fetches all terms and conditions using the usecase.
/// Returns [AsyncValue<List<TermsAndConditions>>] which handles loading, error, and data states.

@ProviderFor(termsAndConditions)
const termsAndConditionsProvider = TermsAndConditionsProvider._();

/// Terms and conditions list provider
///
/// Fetches all terms and conditions using the usecase.
/// Returns [AsyncValue<List<TermsAndConditions>>] which handles loading, error, and data states.

final class TermsAndConditionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TermsAndConditions>>,
          List<TermsAndConditions>,
          FutureOr<List<TermsAndConditions>>
        >
    with
        $FutureModifier<List<TermsAndConditions>>,
        $FutureProvider<List<TermsAndConditions>> {
  /// Terms and conditions list provider
  ///
  /// Fetches all terms and conditions using the usecase.
  /// Returns [AsyncValue<List<TermsAndConditions>>] which handles loading, error, and data states.
  const TermsAndConditionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'termsAndConditionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$termsAndConditionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TermsAndConditions>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TermsAndConditions>> create(Ref ref) {
    return termsAndConditions(ref);
  }
}

String _$termsAndConditionsHash() =>
    r'f4fe9e7224cc2f9d0922dc3186c2225adb0fc176';

/// Privacy policy list provider
///
/// Fetches all privacy policy items using the usecase.
/// Returns [AsyncValue<List<PrivacyPolicy>>] which handles loading, error, and data states.

@ProviderFor(privacyPolicy)
const privacyPolicyProvider = PrivacyPolicyProvider._();

/// Privacy policy list provider
///
/// Fetches all privacy policy items using the usecase.
/// Returns [AsyncValue<List<PrivacyPolicy>>] which handles loading, error, and data states.

final class PrivacyPolicyProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PrivacyPolicy>>,
          List<PrivacyPolicy>,
          FutureOr<List<PrivacyPolicy>>
        >
    with
        $FutureModifier<List<PrivacyPolicy>>,
        $FutureProvider<List<PrivacyPolicy>> {
  /// Privacy policy list provider
  ///
  /// Fetches all privacy policy items using the usecase.
  /// Returns [AsyncValue<List<PrivacyPolicy>>] which handles loading, error, and data states.
  const PrivacyPolicyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyPolicyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyPolicyHash();

  @$internal
  @override
  $FutureProviderElement<List<PrivacyPolicy>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PrivacyPolicy>> create(Ref ref) {
    return privacyPolicy(ref);
  }
}

String _$privacyPolicyHash() => r'9f8154d53e9d29a4a6fc1085e55627415f697612';

/// Submit feedback provider (family)

@ProviderFor(submitFeedback)
const submitFeedbackProvider = SubmitFeedbackFamily._();

/// Submit feedback provider (family)

final class SubmitFeedbackProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Submit feedback provider (family)
  const SubmitFeedbackProvider._({
    required SubmitFeedbackFamily super.from,
    required SubmitFeedbackParams super.argument,
  }) : super(
         retry: null,
         name: r'submitFeedbackProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submitFeedbackHash();

  @override
  String toString() {
    return r'submitFeedbackProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as SubmitFeedbackParams;
    return submitFeedback(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitFeedbackProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submitFeedbackHash() => r'16583a2807550c2c97ec7f3e3bd16a4481ca28c9';

/// Submit feedback provider (family)

final class SubmitFeedbackFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, SubmitFeedbackParams> {
  const SubmitFeedbackFamily._()
    : super(
        retry: null,
        name: r'submitFeedbackProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Submit feedback provider (family)

  SubmitFeedbackProvider call(SubmitFeedbackParams params) =>
      SubmitFeedbackProvider._(argument: params, from: this);

  @override
  String toString() => r'submitFeedbackProvider';
}

/// Submit collaboration request provider (family)

@ProviderFor(submitCollaborationRequest)
const submitCollaborationRequestProvider = SubmitCollaborationRequestFamily._();

/// Submit collaboration request provider (family)

final class SubmitCollaborationRequestProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Submit collaboration request provider (family)
  const SubmitCollaborationRequestProvider._({
    required SubmitCollaborationRequestFamily super.from,
    required SubmitCollaborationRequestParams super.argument,
  }) : super(
         retry: null,
         name: r'submitCollaborationRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submitCollaborationRequestHash();

  @override
  String toString() {
    return r'submitCollaborationRequestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as SubmitCollaborationRequestParams;
    return submitCollaborationRequest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitCollaborationRequestProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submitCollaborationRequestHash() =>
    r'173a6203aee713d0599276e92c21d41337625324';

/// Submit collaboration request provider (family)

final class SubmitCollaborationRequestFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          SubmitCollaborationRequestParams
        > {
  const SubmitCollaborationRequestFamily._()
    : super(
        retry: null,
        name: r'submitCollaborationRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Submit collaboration request provider (family)

  SubmitCollaborationRequestProvider call(
    SubmitCollaborationRequestParams params,
  ) => SubmitCollaborationRequestProvider._(argument: params, from: this);

  @override
  String toString() => r'submitCollaborationRequestProvider';
}

/// Records daily active user (fire-and-forget, errors are swallowed).

@ProviderFor(recordDau)
const recordDauProvider = RecordDauProvider._();

/// Records daily active user (fire-and-forget, errors are swallowed).

final class RecordDauProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Records daily active user (fire-and-forget, errors are swallowed).
  const RecordDauProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordDauProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordDauHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return recordDau(ref);
  }
}

String _$recordDauHash() => r'6dbf2f94761c6de3c4a3c28ffac932be9721b2ac';

/// Fires POST /info/dau when the user is authenticated.
///
/// Initialized once in [YamFoodsApp]. Backend deduplicates repeated calls.

@ProviderFor(dauRecorder)
const dauRecorderProvider = DauRecorderProvider._();

/// Fires POST /info/dau when the user is authenticated.
///
/// Initialized once in [YamFoodsApp]. Backend deduplicates repeated calls.

final class DauRecorderProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Fires POST /info/dau when the user is authenticated.
  ///
  /// Initialized once in [YamFoodsApp]. Backend deduplicates repeated calls.
  const DauRecorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dauRecorderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dauRecorderHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return dauRecorder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$dauRecorderHash() => r'ccb99c1d50066fdd6da072f32aa359412d63b338';
