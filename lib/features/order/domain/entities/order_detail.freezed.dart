// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderDetail {

 Orderr get order; List<OrderItem> get items; OrderAddress? get address;// Nullable because pickup orders don't have addresses
 Payment get payment; OrderBranch? get branch;
/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailCopyWith<OrderDetail> get copyWith => _$OrderDetailCopyWithImpl<OrderDetail>(this as OrderDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.address, address) || other.address == address)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.branch, branch) || other.branch == branch));
}


@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(items),address,payment,branch);

@override
String toString() {
  return 'OrderDetail(order: $order, items: $items, address: $address, payment: $payment, branch: $branch)';
}


}

/// @nodoc
abstract mixin class $OrderDetailCopyWith<$Res>  {
  factory $OrderDetailCopyWith(OrderDetail value, $Res Function(OrderDetail) _then) = _$OrderDetailCopyWithImpl;
@useResult
$Res call({
 Orderr order, List<OrderItem> items, OrderAddress? address, Payment payment, OrderBranch? branch
});


$OrderrCopyWith<$Res> get order;$OrderAddressCopyWith<$Res>? get address;$PaymentCopyWith<$Res> get payment;$OrderBranchCopyWith<$Res>? get branch;

}
/// @nodoc
class _$OrderDetailCopyWithImpl<$Res>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._self, this._then);

  final OrderDetail _self;
  final $Res Function(OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? items = null,Object? address = freezed,Object? payment = null,Object? branch = freezed,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Orderr,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddress?,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as OrderBranch?,
  ));
}
/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderrCopyWith<$Res> get order {
  
  return $OrderrCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentCopyWith<$Res> get payment {
  
  return $PaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderBranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $OrderBranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderDetail].
extension OrderDetailPatterns on OrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Orderr order,  List<OrderItem> items,  OrderAddress? address,  Payment payment,  OrderBranch? branch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Orderr order,  List<OrderItem> items,  OrderAddress? address,  Payment payment,  OrderBranch? branch)  $default,) {final _that = this;
switch (_that) {
case _OrderDetail():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Orderr order,  List<OrderItem> items,  OrderAddress? address,  Payment payment,  OrderBranch? branch)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
return $default(_that.order,_that.items,_that.address,_that.payment,_that.branch);case _:
  return null;

}
}

}

/// @nodoc


class _OrderDetail implements OrderDetail {
  const _OrderDetail({required this.order, required final  List<OrderItem> items, this.address, required this.payment, this.branch}): _items = items;
  

@override final  Orderr order;
 final  List<OrderItem> _items;
@override List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OrderAddress? address;
// Nullable because pickup orders don't have addresses
@override final  Payment payment;
@override final  OrderBranch? branch;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailCopyWith<_OrderDetail> get copyWith => __$OrderDetailCopyWithImpl<_OrderDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.address, address) || other.address == address)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.branch, branch) || other.branch == branch));
}


@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_items),address,payment,branch);

@override
String toString() {
  return 'OrderDetail(order: $order, items: $items, address: $address, payment: $payment, branch: $branch)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailCopyWith<$Res> implements $OrderDetailCopyWith<$Res> {
  factory _$OrderDetailCopyWith(_OrderDetail value, $Res Function(_OrderDetail) _then) = __$OrderDetailCopyWithImpl;
@override @useResult
$Res call({
 Orderr order, List<OrderItem> items, OrderAddress? address, Payment payment, OrderBranch? branch
});


@override $OrderrCopyWith<$Res> get order;@override $OrderAddressCopyWith<$Res>? get address;@override $PaymentCopyWith<$Res> get payment;@override $OrderBranchCopyWith<$Res>? get branch;

}
/// @nodoc
class __$OrderDetailCopyWithImpl<$Res>
    implements _$OrderDetailCopyWith<$Res> {
  __$OrderDetailCopyWithImpl(this._self, this._then);

  final _OrderDetail _self;
  final $Res Function(_OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? items = null,Object? address = freezed,Object? payment = null,Object? branch = freezed,}) {
  return _then(_OrderDetail(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Orderr,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddress?,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as OrderBranch?,
  ));
}

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderrCopyWith<$Res> get order {
  
  return $OrderrCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentCopyWith<$Res> get payment {
  
  return $PaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderBranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $OrderBranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}

// dart format on
