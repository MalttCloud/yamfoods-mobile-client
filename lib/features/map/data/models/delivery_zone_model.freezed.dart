// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_zone_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryZoneModel {

 String get name; List<List<double>> get coordinates;
/// Create a copy of DeliveryZoneModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryZoneModelCopyWith<DeliveryZoneModel> get copyWith => _$DeliveryZoneModelCopyWithImpl<DeliveryZoneModel>(this as DeliveryZoneModel, _$identity);

  /// Serializes this DeliveryZoneModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryZoneModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.coordinates, coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(coordinates));

@override
String toString() {
  return 'DeliveryZoneModel(name: $name, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $DeliveryZoneModelCopyWith<$Res>  {
  factory $DeliveryZoneModelCopyWith(DeliveryZoneModel value, $Res Function(DeliveryZoneModel) _then) = _$DeliveryZoneModelCopyWithImpl;
@useResult
$Res call({
 String name, List<List<double>> coordinates
});




}
/// @nodoc
class _$DeliveryZoneModelCopyWithImpl<$Res>
    implements $DeliveryZoneModelCopyWith<$Res> {
  _$DeliveryZoneModelCopyWithImpl(this._self, this._then);

  final DeliveryZoneModel _self;
  final $Res Function(DeliveryZoneModel) _then;

/// Create a copy of DeliveryZoneModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? coordinates = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<List<double>>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryZoneModel].
extension DeliveryZoneModelPatterns on DeliveryZoneModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryZoneModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryZoneModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryZoneModel value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryZoneModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryZoneModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryZoneModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<List<double>> coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryZoneModel() when $default != null:
return $default(_that.name,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<List<double>> coordinates)  $default,) {final _that = this;
switch (_that) {
case _DeliveryZoneModel():
return $default(_that.name,_that.coordinates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<List<double>> coordinates)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryZoneModel() when $default != null:
return $default(_that.name,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryZoneModel implements DeliveryZoneModel {
  const _DeliveryZoneModel({required this.name, required final  List<List<double>> coordinates}): _coordinates = coordinates;
  factory _DeliveryZoneModel.fromJson(Map<String, dynamic> json) => _$DeliveryZoneModelFromJson(json);

@override final  String name;
 final  List<List<double>> _coordinates;
@override List<List<double>> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}


/// Create a copy of DeliveryZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryZoneModelCopyWith<_DeliveryZoneModel> get copyWith => __$DeliveryZoneModelCopyWithImpl<_DeliveryZoneModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryZoneModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryZoneModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_coordinates));

@override
String toString() {
  return 'DeliveryZoneModel(name: $name, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$DeliveryZoneModelCopyWith<$Res> implements $DeliveryZoneModelCopyWith<$Res> {
  factory _$DeliveryZoneModelCopyWith(_DeliveryZoneModel value, $Res Function(_DeliveryZoneModel) _then) = __$DeliveryZoneModelCopyWithImpl;
@override @useResult
$Res call({
 String name, List<List<double>> coordinates
});




}
/// @nodoc
class __$DeliveryZoneModelCopyWithImpl<$Res>
    implements _$DeliveryZoneModelCopyWith<$Res> {
  __$DeliveryZoneModelCopyWithImpl(this._self, this._then);

  final _DeliveryZoneModel _self;
  final $Res Function(_DeliveryZoneModel) _then;

/// Create a copy of DeliveryZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? coordinates = null,}) {
  return _then(_DeliveryZoneModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<List<double>>,
  ));
}


}

// dart format on
