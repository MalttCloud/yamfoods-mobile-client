import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/promo_code_verification_result.dart';
import '../../../../core/errors/failure.dart';

part 'promo_code_events.g.dart';

sealed class PromoCodeUiEvent {}

class PromoCodeVerified extends PromoCodeUiEvent {
  final PromoCodeVerificationResult result;
  final String message;
  PromoCodeVerified(this.result, this.message);
}

class PromoCodeFailure extends PromoCodeUiEvent {
  final Failure failure;
  PromoCodeFailure(this.failure);
}

@riverpod
class PromoCodeUiEvents extends _$PromoCodeUiEvents {
  @override
  PromoCodeUiEvent? build() {
    return null;
  }

  void emit(PromoCodeUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
