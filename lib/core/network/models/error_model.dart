import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

/// Backend error model.
/// We only trust the [message] field for error classification.
/// Other fields ([code], [details], [retry]) are stored for future use.
@freezed
sealed class ErrorModel with _$ErrorModel {
  const factory ErrorModel({
    required String code,
    required String message,
    String? details,
    String? retry,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
}
