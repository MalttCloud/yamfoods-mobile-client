// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_type_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderTypeConfigModel {

 int get id; String get type; bool get isActive; String? get availableFrom; String? get availableUntil; DateTime get updatedAt;
/// Create a copy of OrderTypeConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTypeConfigModelCopyWith<OrderTypeConfigModel> get copyWith => _$OrderTypeConfigModelCopyWithImpl<OrderTypeConfigModel>(this as OrderTypeConfigModel, _$identity);

  /// Serializes this OrderTypeConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypeConfigModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,isActive,availableFrom,availableUntil,updatedAt);

@override
String toString() {
  return 'OrderTypeConfigModel(id: $id, type: $type, isActive: $isActive, availableFrom: $availableFrom, availableUntil: $availableUntil, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderTypeConfigModelCopyWith<$Res>  {
  factory $OrderTypeConfigModelCopyWith(OrderTypeConfigModel value, $Res Function(OrderTypeConfigModel) _then) = _$OrderTypeConfigModelCopyWithImpl;
@useResult
$Res call({
 int id, String type, bool isActive, String? availableFrom, String? availableUntil, DateTime updatedAt
});




}
/// @nodoc
class _$OrderTypeConfigModelCopyWithImpl<$Res>
    implements $OrderTypeConfigModelCopyWith<$Res> {
  _$OrderTypeConfigModelCopyWithImpl(this._self, this._then);

  final OrderTypeConfigModel _self;
  final $Res Function(OrderTypeConfigModel) _then;

/// Create a copy of OrderTypeConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? isActive = null,Object? availableFrom = freezed,Object? availableUntil = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String?,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTypeConfigModel].
extension OrderTypeConfigModelPatterns on OrderTypeConfigModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTypeConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTypeConfigModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTypeConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderTypeConfigModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTypeConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTypeConfigModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String type,  bool isActive,  String? availableFrom,  String? availableUntil,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTypeConfigModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String type,  bool isActive,  String? availableFrom,  String? availableUntil,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderTypeConfigModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String type,  bool isActive,  String? availableFrom,  String? availableUntil,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderTypeConfigModel() when $default != null:
return $default(_that.id,_that.type,_that.isActive,_that.availableFrom,_that.availableUntil,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderTypeConfigModel implements OrderTypeConfigModel {
  const _OrderTypeConfigModel({required this.id, required this.type, required this.isActive, this.availableFrom, this.availableUntil, required this.updatedAt});
  factory _OrderTypeConfigModel.fromJson(Map<String, dynamic> json) => _$OrderTypeConfigModelFromJson(json);

@override final  int id;
@override final  String type;
@override final  bool isActive;
@override final  String? availableFrom;
@override final  String? availableUntil;
@override final  DateTime updatedAt;

/// Create a copy of OrderTypeConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTypeConfigModelCopyWith<_OrderTypeConfigModel> get copyWith => __$OrderTypeConfigModelCopyWithImpl<_OrderTypeConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderTypeConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTypeConfigModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,isActive,availableFrom,availableUntil,updatedAt);

@override
String toString() {
  return 'OrderTypeConfigModel(id: $id, type: $type, isActive: $isActive, availableFrom: $availableFrom, availableUntil: $availableUntil, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderTypeConfigModelCopyWith<$Res> implements $OrderTypeConfigModelCopyWith<$Res> {
  factory _$OrderTypeConfigModelCopyWith(_OrderTypeConfigModel value, $Res Function(_OrderTypeConfigModel) _then) = __$OrderTypeConfigModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String type, bool isActive, String? availableFrom, String? availableUntil, DateTime updatedAt
});




}
/// @nodoc
class __$OrderTypeConfigModelCopyWithImpl<$Res>
    implements _$OrderTypeConfigModelCopyWith<$Res> {
  __$OrderTypeConfigModelCopyWithImpl(this._self, this._then);

  final _OrderTypeConfigModel _self;
  final $Res Function(_OrderTypeConfigModel) _then;

/// Create a copy of OrderTypeConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? isActive = null,Object? availableFrom = freezed,Object? availableUntil = freezed,Object? updatedAt = null,}) {
  return _then(_OrderTypeConfigModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String?,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
