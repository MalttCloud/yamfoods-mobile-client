import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'profile_providers.dart';
import 'profile_events.dart';

part 'profile_notifier.g.dart';

/// Manages profile update and password change operations.
///
/// **State Management:**
/// - Emits UI events for success/failure
/// - Tracks loading state (true = loading, false = not loading)
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  bool build() => false; // false = not loading

  Future<void> updateProfile({
    String? name,
    String? email,
    File? imageFile,
  }) async {
    state = true; // loading
    try {
      final useCase = await ref.read(updateProfileUseCaseProvider.future);
      final result = await useCase.call(
        name: name,
        email: email,
        imageFile: imageFile,
      );

      result.fold(
        (failure) {
          ref
              .read(profileUiEventsProvider.notifier)
              .emit(ProfileFailure(failure));
        },
        (user) {
          ref
              .read(profileUiEventsProvider.notifier)
              .emit(ProfileUpdated(user, 'Profile updated successfully'));
        },
      );
    } finally {
      state = false; // not loading
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = true; // loading
    try {
      final useCase = await ref.read(changePasswordUseCaseProvider.future);
      final result = await useCase.call(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      result.fold(
        (failure) {
          ref
              .read(profileUiEventsProvider.notifier)
              .emit(ProfileFailure(failure));
        },
        (user) {
          ref
              .read(profileUiEventsProvider.notifier)
              .emit(PasswordChanged(user, 'Password changed successfully'));
        },
      );
    } finally {
      state = false; // not loading
    }
  }
}
