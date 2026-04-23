// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderDetailModel {

 OrderModel get order; List<OrderItemModel> get items; OrderAddressModel? get address;// Nullable because pickup orders don't have addresses
 PaymentModel get payment; OrderBranchModel? get branch;
/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailModelCopyWith<OrderDetailModel> get copyWith => _$OrderDetailModelCopyWithImpl<OrderDetailModel>(this as OrderDetailModel, _$identity);

  /// Serializes this OrderDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailModel&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.address, address) || other.address == address)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.branch, branch) || other.branch == branch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(items),address,payment,branch);

@override
String toString() {
  return 'OrderDetailModel(order: $order, items: $items, address: $address, payment: $payment, branch: $branch)';
}


}

/// @nodoc
abstract mixin class $OrderDetailModelCopyWith<$Res>  {
  factory $OrderDetailModelCopyWith(OrderDetailModel value, $Res Function(OrderDetailModel) _then) = _$OrderDetailModelCopyWithImpl;
@useResult
$Res call({
 OrderModel order, List<OrderItemModel> items, OrderAddressModel? address, PaymentModel payment, OrderBranchModel? branch
});


$OrderModelCopyWith<$Res> get order;$OrderAddressModelCopyWith<$Res>? get address;$PaymentModelCopyWith<$Res> get payment;$OrderBranchModelCopyWith<$Res>? get branch;

}
/// @nodoc
class _$OrderDetailModelCopyWithImpl<$Res>
    implements $OrderDetailModelCopyWith<$Res> {
  _$OrderDetailModelCopyWithImpl(this._self, this._then);

  final OrderDetailModel _self;
  final $Res Function(OrderDetailModel) _then;

/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? items = null,Object? address = freezed,Object? payment = null,Object? branch = freezed,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderModel,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddressModel?,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentModel,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as OrderBranchModel?,
  ));
}
/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderModelCopyWith<$Res> get order {
  
  return $OrderModelCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<$Res> get payment {
  
  return $PaymentModelCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderBranchModelCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $OrderBranchModelCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderDetailModel].
extension OrderDetailModelPatterns on OrderDetailModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetailModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetailModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetailModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrderModel order,  List<OrderItemModel> items,  OrderAddressModel? address,  PaymentModel payment,  OrderBranchModel? branch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetailModel() when $default != null:
return $default(_that.order,_that.items,_that.address,_that.payment,_that.branch);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrderModel order,  List<OrderItemModel> items,  OrderAddressModel? address,  PaymentModel payment,  OrderBranchModel? branch)  $default,) {final _that = this;
switch (_that) {
case _OrderDetailModel():
return $default(_that.order,_that.items,_that.address,_that.payment,_that.branch);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrderModel order,  List<OrderItemModel> items,  OrderAddressModel? address,  PaymentModel payment,  OrderBranchModel? branch)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetailModel() when $default != null:
return $default(_that.order,_that.items,_that.address,_that.payment,_that.branch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderDetailModel extends OrderDetailModel {
  const _OrderDetailModel({required this.order, required final  List<OrderItemModel> items, this.address, required this.payment, this.branch}): _items = items,super._();
  factory _OrderDetailModel.fromJson(Map<String, dynamic> json) => _$OrderDetailModelFromJson(json);

@override final  OrderModel order;
 final  List<OrderItemModel> _items;
@override List<OrderItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OrderAddressModel? address;
// Nullable because pickup orders don't have addresses
@override final  PaymentModel payment;
@override final  OrderBranchModel? branch;

/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailModelCopyWith<_OrderDetailModel> get copyWith => __$OrderDetailModelCopyWithImpl<_OrderDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetailModel&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.address, address) || other.address == address)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.branch, branch) || other.branch == branch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_items),address,payment,branch);

@override
String toString() {
  return 'OrderDetailModel(order: $order, items: $items, address: $address, payment: $payment, branch: $branch)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailModelCopyWith<$Res> implements $OrderDetailModelCopyWith<$Res> {
  factory _$OrderDetailModelCopyWith(_OrderDetailModel value, $Res Function(_OrderDetailModel) _then) = __$OrderDetailModelCopyWithImpl;
@override @useResult
$Res call({
 OrderModel order, List<OrderItemModel> items, OrderAddressModel? address, PaymentModel payment, OrderBranchModel? branch
});


@override $OrderModelCopyWith<$Res> get order;@override $OrderAddressModelCopyWith<$Res>? get address;@override $PaymentModelCopyWith<$Res> get payment;@override $OrderBranchModelCopyWith<$Res>? get branch;

}
/// @nodoc
class __$OrderDetailModelCopyWithImpl<$Res>
    implements _$OrderDetailModelCopyWith<$Res> {
  __$OrderDetailModelCopyWithImpl(this._self, this._then);

  final _OrderDetailModel _self;
  final $Res Function(_OrderDetailModel) _then;

/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? items = null,Object? address = freezed,Object? payment = null,Object? branch = freezed,}) {
  return _then(_OrderDetailModel(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderModel,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddressModel?,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentModel,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as OrderBranchModel?,
  ));
}

/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderModelCopyWith<$Res> get order {
  
  return $OrderModelCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<$Res> get payment {
  
  return $PaymentModelCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of OrderDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderBranchModelCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $OrderBranchModelCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}

// dart format on
