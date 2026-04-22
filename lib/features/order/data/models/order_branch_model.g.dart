// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderBranchModel _$OrderBranchModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OrderBranchModel', json, ($checkedConvert) {
      final val = _OrderBranchModel(
        name: $checkedConvert('name', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        contactPhone: $checkedConvert('contactPhone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$OrderBranchModelToJson(_OrderBranchModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'contactPhone': instance.contactPhone,
    };
