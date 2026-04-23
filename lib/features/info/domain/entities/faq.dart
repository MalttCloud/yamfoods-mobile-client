import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq.freezed.dart';

@freezed
sealed class Faq with _$Faq {
  const factory Faq({
    required int id,
    required String question,
    required String answer,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Faq;
}
