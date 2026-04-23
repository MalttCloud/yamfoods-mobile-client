import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_and_conditions.freezed.dart';

@freezed
sealed class TermsAndConditions with _$TermsAndConditions {
  const factory TermsAndConditions({
    required int id,
    required String title,
    required String description,
    String? link,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TermsAndConditions;
}
