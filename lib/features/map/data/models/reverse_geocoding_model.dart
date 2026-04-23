// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reverse_geocoding_model.freezed.dart';
part 'reverse_geocoding_model.g.dart';

@freezed
sealed class ReverseGeocodingModel with _$ReverseGeocodingModel {
  const factory ReverseGeocodingModel({
    @JsonKey(name: 'results', fromJson: _resultsFromJson)
    required List<String> formattedAddresses,
  }) = _ReverseGeocodingModel;

  factory ReverseGeocodingModel.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodingModelFromJson(json);
}

/// Extracts only the 'formatted' field from each result in the results array
List<String> _resultsFromJson(List<dynamic> json) {
  return json
      .map((result) => (result as Map<String, dynamic>)['formatted'] as String)
      .toList();
}
