import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';

part 'profile_events.g.dart';

sealed class ProfileUiEvent {}

class ProfileUpdated extends ProfileUiEvent {
  final User user;
  final String message;
  ProfileUpdated(this.user, this.message);
}

class PasswordChanged extends ProfileUiEvent {
  final User user;
  final String message;
  PasswordChanged(this.user, this.message);
}

class ProfileFailure extends ProfileUiEvent {
  final Failure failure;
  ProfileFailure(this.failure);
}

@riverpod
class ProfileUiEvents extends _$ProfileUiEvents {
  @override
  ProfileUiEvent? build() {
    return null;
  }

  void emit(ProfileUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
