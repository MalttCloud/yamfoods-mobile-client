// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserModel', json, ($checkedConvert) {
  final val = _UserModel(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    imageUrl: $checkedConvert('imageUrl', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String?),
    role: $checkedConvert('role', (v) => v as String),
    email: $checkedConvert('email', (v) => v as String),
    phoneVerified: $checkedConvert('phoneVerified', (v) => (v as num).toInt()),
    referralCode: $checkedConvert('referralCode', (v) => v as String?),
    googleId: $checkedConvert('googleId', (v) => v as String?),
    provider: $checkedConvert('provider', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'email': instance.email,
      'phoneVerified': instance.phoneVerified,
      'referralCode': instance.referralCode,
      'googleId': instance.googleId,
      'provider': instance.provider,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
