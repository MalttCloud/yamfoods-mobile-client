// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderBranch {

 String get name; String get address; String get contactPhone;
/// Create a copy of OrderBranch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderBranchCopyWith<OrderBranch> get copyWith => _$OrderBranchCopyWithImpl<OrderBranch>(this as OrderBranch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderBranch&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}


@override
int get hashCode => Object.hash(runtimeType,name,address,contactPhone);

@override
String toString() {
  return 'OrderBranch(name: $name, address: $address, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class $OrderBranchCopyWith<$Res>  {
  factory $OrderBranchCopyWith(OrderBranch value, $Res Function(OrderBranch) _then) = _$OrderBranchCopyWithImpl;
@useResult
$Res call({
 String name, String address, String contactPhone
});




}
/// @nodoc
class _$OrderBranchCopyWithImpl<$Res>
    implements $OrderBranchCopyWith<$Res> {
  _$OrderBranchCopyWithImpl(this._self, this._then);

  final OrderBranch _self;
  final $Res Function(OrderBranch) _then;

/// Create a copy of OrderBranch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,Object? contactPhone = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderBranch].
extension OrderBranchPatterns on OrderBranch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderBranch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderBranch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderBranch value)  $default,){
final _that = this;
switch (_that) {
case _OrderBranch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderBranch value)?  $default,){
final _that = this;
switch (_that) {
case _OrderBranch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String address,  String contactPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderBranch() when $default != null:
return $default(_that.name,_that.address,_that.contactPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String address,  String contactPhone)  $default,) {final _that = this;
switch (_that) {
case _OrderBranch():
return $default(_that.name,_that.address,_that.contactPhone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String address,  String contactPhone)?  $default,) {final _that = this;
switch (_that) {
case _OrderBranch() when $default != null:
return $default(_that.name,_that.address,_that.contactPhone);case _:
  return null;

}
}

}

/// @nodoc


class _OrderBranch implements OrderBranch {
  const _OrderBranch({required this.name, required this.address, required this.contactPhone});
  

@override final  String name;
@override final  String address;
@override final  String contactPhone;

/// Create a copy of OrderBranch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderBranchCopyWith<_OrderBranch> get copyWith => __$OrderBranchCopyWithImpl<_OrderBranch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderBranch&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}


@override
int get hashCode => Object.hash(runtimeType,name,address,contactPhone);

@override
String toString() {
  return 'OrderBranch(name: $name, address: $address, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class _$OrderBranchCopyWith<$Res> implements $OrderBranchCopyWith<$Res> {
  factory _$OrderBranchCopyWith(_OrderBranch value, $Res Function(_OrderBranch) _then) = __$OrderBranchCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, String contactPhone
});




}
/// @nodoc
class __$OrderBranchCopyWithImpl<$Res>
    implements _$OrderBranchCopyWith<$Res> {
  __$OrderBranchCopyWithImpl(this._self, this._then);

  final _OrderBranch _self;
  final $Res Function(_OrderBranch) _then;

/// Create a copy of OrderBranch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? contactPhone = null,}) {
  return _then(_OrderBranch(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
