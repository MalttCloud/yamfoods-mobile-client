import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_code_loading_providers.g.dart';

@riverpod
class PromoCodeVerificationLoading extends _$PromoCodeVerificationLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}
