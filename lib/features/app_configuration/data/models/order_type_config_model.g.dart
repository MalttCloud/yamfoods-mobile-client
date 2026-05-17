// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_type_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderTypeConfigModel _$OrderTypeConfigModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_OrderTypeConfigModel', json, ($checkedConvert) {
  final val = _OrderTypeConfigModel(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    type: $checkedConvert('type', (v) => v as String),
    isActive: $checkedConvert('isActive', (v) => v as bool),
    availableFrom: $checkedConvert('availableFrom', (v) => v as String?),
    availableUntil: $checkedConvert('availableUntil', (v) => v as String?),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$OrderTypeConfigModelToJson(
  _OrderTypeConfigModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'isActive': instance.isActive,
  'availableFrom': instance.availableFrom,
  'availableUntil': instance.availableUntil,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
