// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_type_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderTypeConfig {

 int get id; OrderType get type; bool get isActive; TimeOfDay? get availableFrom; TimeOfDay? get availableUntil; DateTime get updatedAt;
/// Create a copy of OrderTypeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTypeConfigCopyWith<OrderTypeConfig> get copyWith => _$OrderTypeConfigCopyWithImpl<OrderTypeConfig>(this as OrderTypeConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,isActive,availableFrom,availableUntil,updatedAt);

@override
String toString() {
  return 'OrderTypeConfig(id: $id, type: $type, isActive: $isActive, availableFrom: $availableFrom, availableUntil: $availableUntil, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderTypeConfigCopyWith<$Res>  {
  factory $OrderTypeConfigCopyWith(OrderTypeConfig value, $Res Function(OrderTypeConfig) _then) = _$OrderTypeConfigCopyWithImpl;
@useResult
$Res call({
 int id, OrderType type, bool isActive, TimeOfDay? availableFrom, TimeOfDay? availableUntil, DateTime updatedAt
});




}
/// @nodoc
class _$OrderTypeConfigCopyWithImpl<$Res>
    implements $OrderTypeConfigCopyWith<$Res> {
  _$OrderTypeConfigCopyWithImpl(this._self, this._then);

  final OrderTypeConfig _self;
  final $Res Function(OrderTypeConfig) _then;

/// Create a copy of OrderTypeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? isActive = null,Object? availableFrom = freezed,Object? availableUntil = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTypeConfig].
extension OrderTypeConfigPatterns on OrderTypeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTypeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTypeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTypeConfig value)  $default,){
final _that = this;
switch (_that) {
case _OrderTypeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTypeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTypeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  OrderType type,  bool isActive,  TimeOfDay? availableFrom,  TimeOfDay? availableUntil,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTypeConfig() when $default != null:
return $default(_that.id,_that.type,_that.isActive,_that.availableFrom,_that.availableUntil,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  OrderType type,  bool isActive,  TimeOfDay? availableFrom,  TimeOfDay? availableUntil,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderTypeConfig():
return $default(_that.id,_that.type,_that.isActive,_that.availableFrom,_that.availableUntil,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  OrderType type,  bool isActive,  TimeOfDay? availableFrom,  TimeOfDay? availableUntil,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderTypeConfig() when $default != null:
return $default(_that.id,_that.type,_that.isActive,_that.availableFrom,_that.availableUntil,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderTypeConfig implements OrderTypeConfig {
  const _OrderTypeConfig({required this.id, required this.type, required this.isActive, this.availableFrom, this.availableUntil, required this.updatedAt});
  

@override final  int id;
@override final  OrderType type;
@override final  bool isActive;
@override final  TimeOfDay? availableFrom;
@override final  TimeOfDay? availableUntil;
@override final  DateTime updatedAt;

/// Create a copy of OrderTypeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTypeConfigCopyWith<_OrderTypeConfig> get copyWith => __$OrderTypeConfigCopyWithImpl<_OrderTypeConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTypeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,isActive,availableFrom,availableUntil,updatedAt);

@override
String toString() {
  return 'OrderTypeConfig(id: $id, type: $type, isActive: $isActive, availableFrom: $availableFrom, availableUntil: $availableUntil, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderTypeConfigCopyWith<$Res> implements $OrderTypeConfigCopyWith<$Res> {
  factory _$OrderTypeConfigCopyWith(_OrderTypeConfig value, $Res Function(_OrderTypeConfig) _then) = __$OrderTypeConfigCopyWithImpl;
@override @useResult
$Res call({
 int id, OrderType type, bool isActive, TimeOfDay? availableFrom, TimeOfDay? availableUntil, DateTime updatedAt
});




}
/// @nodoc
class __$OrderTypeConfigCopyWithImpl<$Res>
    implements _$OrderTypeConfigCopyWith<$Res> {
  __$OrderTypeConfigCopyWithImpl(this._self, this._then);

  final _OrderTypeConfig _self;
  final $Res Function(_OrderTypeConfig) _then;

/// Create a copy of OrderTypeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? isActive = null,Object? availableFrom = freezed,Object? availableUntil = freezed,Object? updatedAt = null,}) {
  return _then(_OrderTypeConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
