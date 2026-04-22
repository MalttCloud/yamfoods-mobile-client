// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_branch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderBranchModel {

 String get name; String get address; String get contactPhone;
/// Create a copy of OrderBranchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderBranchModelCopyWith<OrderBranchModel> get copyWith => _$OrderBranchModelCopyWithImpl<OrderBranchModel>(this as OrderBranchModel, _$identity);

  /// Serializes this OrderBranchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderBranchModel&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,contactPhone);

@override
String toString() {
  return 'OrderBranchModel(name: $name, address: $address, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class $OrderBranchModelCopyWith<$Res>  {
  factory $OrderBranchModelCopyWith(OrderBranchModel value, $Res Function(OrderBranchModel) _then) = _$OrderBranchModelCopyWithImpl;
@useResult
$Res call({
 String name, String address, String contactPhone
});




}
/// @nodoc
class _$OrderBranchModelCopyWithImpl<$Res>
    implements $OrderBranchModelCopyWith<$Res> {
  _$OrderBranchModelCopyWithImpl(this._self, this._then);

  final OrderBranchModel _self;
  final $Res Function(OrderBranchModel) _then;

/// Create a copy of OrderBranchModel
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


/// Adds pattern-matching-related methods to [OrderBranchModel].
extension OrderBranchModelPatterns on OrderBranchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderBranchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderBranchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderBranchModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderBranchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderBranchModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderBranchModel() when $default != null:
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
case _OrderBranchModel() when $default != null:
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
case _OrderBranchModel():
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
case _OrderBranchModel() when $default != null:
return $default(_that.name,_that.address,_that.contactPhone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderBranchModel implements OrderBranchModel {
  const _OrderBranchModel({required this.name, required this.address, required this.contactPhone});
  factory _OrderBranchModel.fromJson(Map<String, dynamic> json) => _$OrderBranchModelFromJson(json);

@override final  String name;
@override final  String address;
@override final  String contactPhone;

/// Create a copy of OrderBranchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderBranchModelCopyWith<_OrderBranchModel> get copyWith => __$OrderBranchModelCopyWithImpl<_OrderBranchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderBranchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderBranchModel&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,contactPhone);

@override
String toString() {
  return 'OrderBranchModel(name: $name, address: $address, contactPhone: $contactPhone)';
}


}

/// @nodoc
abstract mixin class _$OrderBranchModelCopyWith<$Res> implements $OrderBranchModelCopyWith<$Res> {
  factory _$OrderBranchModelCopyWith(_OrderBranchModel value, $Res Function(_OrderBranchModel) _then) = __$OrderBranchModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, String contactPhone
});




}
/// @nodoc
class __$OrderBranchModelCopyWithImpl<$Res>
    implements _$OrderBranchModelCopyWith<$Res> {
  __$OrderBranchModelCopyWithImpl(this._self, this._then);

  final _OrderBranchModel _self;
  final $Res Function(_OrderBranchModel) _then;

/// Create a copy of OrderBranchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? contactPhone = null,}) {
  return _then(_OrderBranchModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
