// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_model.freezed.dart';
part 'meta_model.g.dart';

/// Metadata model for API responses.
@freezed
sealed class MetaModel with _$MetaModel {
  const factory MetaModel({
    @JsonKey(name: 'request_id') required String requestId,
    required String timestamp,
  }) = _MetaModel;

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);
}
