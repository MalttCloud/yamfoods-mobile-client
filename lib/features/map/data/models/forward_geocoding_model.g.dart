// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forward_geocoding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForwardGeocodingResponse _$ForwardGeocodingResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ForwardGeocodingResponse', json, ($checkedConvert) {
  final val = _ForwardGeocodingResponse(
    data: $checkedConvert(
      'data',
      (v) => ForwardGeocodingData.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ForwardGeocodingResponseToJson(
  _ForwardGeocodingResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};

_ForwardGeocodingData _$ForwardGeocodingDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ForwardGeocodingData', json, ($checkedConvert) {
  final val = _ForwardGeocodingData(
    results: $checkedConvert(
      'results',
      (v) => (v as List<dynamic>)
          .map((e) => FGAddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ForwardGeocodingDataToJson(
  _ForwardGeocodingData instance,
) => <String, dynamic>{
  'results': instance.results.map((e) => e.toJson()).toList(),
};

_FGAddressModel _$FGAddressModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FGAddressModel', json, ($checkedConvert) {
      final val = _FGAddressModel(
        displayName: $checkedConvert('display_name', (v) => v as String),
        location: $checkedConvert(
          'location',
          (v) => FGLocationModel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'displayName': 'display_name'});

Map<String, dynamic> _$FGAddressModelToJson(_FGAddressModel instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'location': instance.location.toJson(),
    };

_FGLocationModel _$FGLocationModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FGLocationModel', json, ($checkedConvert) {
      final val = _FGLocationModel(
        lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
        lng: $checkedConvert('lng', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$FGLocationModelToJson(_FGLocationModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
