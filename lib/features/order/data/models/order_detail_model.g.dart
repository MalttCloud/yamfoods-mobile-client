// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OrderDetailModel', json, ($checkedConvert) {
      final val = _OrderDetailModel(
        order: $checkedConvert(
          'order',
          (v) => OrderModel.fromJson(v as Map<String, dynamic>),
        ),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        address: $checkedConvert(
          'address',
          (v) => v == null
              ? null
              : OrderAddressModel.fromJson(v as Map<String, dynamic>),
        ),
        payment: $checkedConvert(
          'payment',
          (v) => PaymentModel.fromJson(v as Map<String, dynamic>),
        ),
        branch: $checkedConvert(
          'branch',
          (v) => v == null
              ? null
              : OrderBranchModel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OrderDetailModelToJson(_OrderDetailModel instance) =>
    <String, dynamic>{
      'order': instance.order.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'address': instance.address?.toJson(),
      'payment': instance.payment.toJson(),
      'branch': instance.branch?.toJson(),
    };
