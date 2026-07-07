// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_address_selection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeliveryAddressSelectionState {

 double? get selectedLat; double? get selectedLng; String? get selectedPlaceName; PlaceNameStatus get placeNameStatus;
/// Create a copy of DeliveryAddressSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryAddressSelectionStateCopyWith<DeliveryAddressSelectionState> get copyWith => _$DeliveryAddressSelectionStateCopyWithImpl<DeliveryAddressSelectionState>(this as DeliveryAddressSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryAddressSelectionState&&(identical(other.selectedLat, selectedLat) || other.selectedLat == selectedLat)&&(identical(other.selectedLng, selectedLng) || other.selectedLng == selectedLng)&&(identical(other.selectedPlaceName, selectedPlaceName) || other.selectedPlaceName == selectedPlaceName)&&(identical(other.placeNameStatus, placeNameStatus) || other.placeNameStatus == placeNameStatus));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLat,selectedLng,selectedPlaceName,placeNameStatus);

@override
String toString() {
  return 'DeliveryAddressSelectionState(selectedLat: $selectedLat, selectedLng: $selectedLng, selectedPlaceName: $selectedPlaceName, placeNameStatus: $placeNameStatus)';
}


}

/// @nodoc
abstract mixin class $DeliveryAddressSelectionStateCopyWith<$Res>  {
  factory $DeliveryAddressSelectionStateCopyWith(DeliveryAddressSelectionState value, $Res Function(DeliveryAddressSelectionState) _then) = _$DeliveryAddressSelectionStateCopyWithImpl;
@useResult
$Res call({
 double? selectedLat, double? selectedLng, String? selectedPlaceName, PlaceNameStatus placeNameStatus
});




}
/// @nodoc
class _$DeliveryAddressSelectionStateCopyWithImpl<$Res>
    implements $DeliveryAddressSelectionStateCopyWith<$Res> {
  _$DeliveryAddressSelectionStateCopyWithImpl(this._self, this._then);

  final DeliveryAddressSelectionState _self;
  final $Res Function(DeliveryAddressSelectionState) _then;

/// Create a copy of DeliveryAddressSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedLat = freezed,Object? selectedLng = freezed,Object? selectedPlaceName = freezed,Object? placeNameStatus = null,}) {
  return _then(_self.copyWith(
selectedLat: freezed == selectedLat ? _self.selectedLat : selectedLat // ignore: cast_nullable_to_non_nullable
as double?,selectedLng: freezed == selectedLng ? _self.selectedLng : selectedLng // ignore: cast_nullable_to_non_nullable
as double?,selectedPlaceName: freezed == selectedPlaceName ? _self.selectedPlaceName : selectedPlaceName // ignore: cast_nullable_to_non_nullable
as String?,placeNameStatus: null == placeNameStatus ? _self.placeNameStatus : placeNameStatus // ignore: cast_nullable_to_non_nullable
as PlaceNameStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryAddressSelectionState].
extension DeliveryAddressSelectionStatePatterns on DeliveryAddressSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryAddressSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryAddressSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryAddressSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? selectedLat,  double? selectedLng,  String? selectedPlaceName,  PlaceNameStatus placeNameStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState() when $default != null:
return $default(_that.selectedLat,_that.selectedLng,_that.selectedPlaceName,_that.placeNameStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? selectedLat,  double? selectedLng,  String? selectedPlaceName,  PlaceNameStatus placeNameStatus)  $default,) {final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState():
return $default(_that.selectedLat,_that.selectedLng,_that.selectedPlaceName,_that.placeNameStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? selectedLat,  double? selectedLng,  String? selectedPlaceName,  PlaceNameStatus placeNameStatus)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryAddressSelectionState() when $default != null:
return $default(_that.selectedLat,_that.selectedLng,_that.selectedPlaceName,_that.placeNameStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DeliveryAddressSelectionState implements DeliveryAddressSelectionState {
  const _DeliveryAddressSelectionState({this.selectedLat, this.selectedLng, this.selectedPlaceName, this.placeNameStatus = PlaceNameStatus.idle});
  

@override final  double? selectedLat;
@override final  double? selectedLng;
@override final  String? selectedPlaceName;
@override@JsonKey() final  PlaceNameStatus placeNameStatus;

/// Create a copy of DeliveryAddressSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryAddressSelectionStateCopyWith<_DeliveryAddressSelectionState> get copyWith => __$DeliveryAddressSelectionStateCopyWithImpl<_DeliveryAddressSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryAddressSelectionState&&(identical(other.selectedLat, selectedLat) || other.selectedLat == selectedLat)&&(identical(other.selectedLng, selectedLng) || other.selectedLng == selectedLng)&&(identical(other.selectedPlaceName, selectedPlaceName) || other.selectedPlaceName == selectedPlaceName)&&(identical(other.placeNameStatus, placeNameStatus) || other.placeNameStatus == placeNameStatus));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLat,selectedLng,selectedPlaceName,placeNameStatus);

@override
String toString() {
  return 'DeliveryAddressSelectionState(selectedLat: $selectedLat, selectedLng: $selectedLng, selectedPlaceName: $selectedPlaceName, placeNameStatus: $placeNameStatus)';
}


}

/// @nodoc
abstract mixin class _$DeliveryAddressSelectionStateCopyWith<$Res> implements $DeliveryAddressSelectionStateCopyWith<$Res> {
  factory _$DeliveryAddressSelectionStateCopyWith(_DeliveryAddressSelectionState value, $Res Function(_DeliveryAddressSelectionState) _then) = __$DeliveryAddressSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 double? selectedLat, double? selectedLng, String? selectedPlaceName, PlaceNameStatus placeNameStatus
});




}
/// @nodoc
class __$DeliveryAddressSelectionStateCopyWithImpl<$Res>
    implements _$DeliveryAddressSelectionStateCopyWith<$Res> {
  __$DeliveryAddressSelectionStateCopyWithImpl(this._self, this._then);

  final _DeliveryAddressSelectionState _self;
  final $Res Function(_DeliveryAddressSelectionState) _then;

/// Create a copy of DeliveryAddressSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedLat = freezed,Object? selectedLng = freezed,Object? selectedPlaceName = freezed,Object? placeNameStatus = null,}) {
  return _then(_DeliveryAddressSelectionState(
selectedLat: freezed == selectedLat ? _self.selectedLat : selectedLat // ignore: cast_nullable_to_non_nullable
as double?,selectedLng: freezed == selectedLng ? _self.selectedLng : selectedLng // ignore: cast_nullable_to_non_nullable
as double?,selectedPlaceName: freezed == selectedPlaceName ? _self.selectedPlaceName : selectedPlaceName // ignore: cast_nullable_to_non_nullable
as String?,placeNameStatus: null == placeNameStatus ? _self.placeNameStatus : placeNameStatus // ignore: cast_nullable_to_non_nullable
as PlaceNameStatus,
  ));
}


}

// dart format on
