import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required int id,
    String? imageUrl,
    required String name,
    String? phone,
    required String role,
    required String email,
    required bool phoneVerified,
    String? googleId,
    required String provider,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;
}

