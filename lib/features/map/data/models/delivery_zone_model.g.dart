// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_zone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryZoneModel _$DeliveryZoneModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DeliveryZoneModel', json, ($checkedConvert) {
      final val = _DeliveryZoneModel(
        name: $checkedConvert('name', (v) => v as String),
        coordinates: $checkedConvert(
          'coordinates',
          (v) => (v as List<dynamic>)
              .map(
                (e) => (e as List<dynamic>)
                    .map((e) => (e as num).toDouble())
                    .toList(),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeliveryZoneModelToJson(_DeliveryZoneModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coordinates': instance.coordinates,
    };
