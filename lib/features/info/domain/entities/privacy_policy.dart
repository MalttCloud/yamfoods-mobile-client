import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policy.freezed.dart';

@freezed
sealed class PrivacyPolicy with _$PrivacyPolicy {
  const factory PrivacyPolicy({
    required int id,
    required String title,
    required String description,
    String? link,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PrivacyPolicy;
}
