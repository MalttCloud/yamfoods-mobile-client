// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forward_geocoding_model.freezed.dart';
part 'forward_geocoding_model.g.dart';

@freezed
sealed class ForwardGeocodingResponse with _$ForwardGeocodingResponse {
  const factory ForwardGeocodingResponse({
    required ForwardGeocodingData data,
  }) = _ForwardGeocodingResponse;

  factory ForwardGeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$ForwardGeocodingResponseFromJson(json);
}

@freezed
sealed class ForwardGeocodingData with _$ForwardGeocodingData {
  const factory ForwardGeocodingData({
    required List<FGAddressModel> results,
  }) = _ForwardGeocodingData;

  factory ForwardGeocodingData.fromJson(Map<String, dynamic> json) =>
      _$ForwardGeocodingDataFromJson(json);
}

@freezed
sealed class FGAddressModel with _$FGAddressModel {
  const factory FGAddressModel({
    @JsonKey(name: 'display_name') required String displayName,
    required FGLocationModel location,
  }) = _FGAddressModel;

  factory FGAddressModel.fromJson(Map<String, dynamic> json) =>
      _$FGAddressModelFromJson(json);
}

@freezed
sealed class FGLocationModel with _$FGLocationModel {
  const factory FGLocationModel({
    required double lat,
    required double lng,
  }) = _FGLocationModel;

  factory FGLocationModel.fromJson(Map<String, dynamic> json) =>
      _$FGLocationModelFromJson(json);
}
