// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forward_geocoding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForwardGeocodingResponse {

 ForwardGeocodingData get data;
/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForwardGeocodingResponseCopyWith<ForwardGeocodingResponse> get copyWith => _$ForwardGeocodingResponseCopyWithImpl<ForwardGeocodingResponse>(this as ForwardGeocodingResponse, _$identity);

  /// Serializes this ForwardGeocodingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForwardGeocodingResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ForwardGeocodingResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $ForwardGeocodingResponseCopyWith<$Res>  {
  factory $ForwardGeocodingResponseCopyWith(ForwardGeocodingResponse value, $Res Function(ForwardGeocodingResponse) _then) = _$ForwardGeocodingResponseCopyWithImpl;
@useResult
$Res call({
 ForwardGeocodingData data
});


$ForwardGeocodingDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ForwardGeocodingResponseCopyWithImpl<$Res>
    implements $ForwardGeocodingResponseCopyWith<$Res> {
  _$ForwardGeocodingResponseCopyWithImpl(this._self, this._then);

  final ForwardGeocodingResponse _self;
  final $Res Function(ForwardGeocodingResponse) _then;

/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ForwardGeocodingData,
  ));
}
/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForwardGeocodingDataCopyWith<$Res> get data {
  
  return $ForwardGeocodingDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForwardGeocodingResponse].
extension ForwardGeocodingResponsePatterns on ForwardGeocodingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForwardGeocodingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForwardGeocodingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForwardGeocodingResponse value)  $default,){
final _that = this;
switch (_that) {
case _ForwardGeocodingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForwardGeocodingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ForwardGeocodingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ForwardGeocodingData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForwardGeocodingResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ForwardGeocodingData data)  $default,) {final _that = this;
switch (_that) {
case _ForwardGeocodingResponse():
return $default(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ForwardGeocodingData data)?  $default,) {final _that = this;
switch (_that) {
case _ForwardGeocodingResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForwardGeocodingResponse implements ForwardGeocodingResponse {
  const _ForwardGeocodingResponse({required this.data});
  factory _ForwardGeocodingResponse.fromJson(Map<String, dynamic> json) => _$ForwardGeocodingResponseFromJson(json);

@override final  ForwardGeocodingData data;

/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForwardGeocodingResponseCopyWith<_ForwardGeocodingResponse> get copyWith => __$ForwardGeocodingResponseCopyWithImpl<_ForwardGeocodingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForwardGeocodingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForwardGeocodingResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ForwardGeocodingResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ForwardGeocodingResponseCopyWith<$Res> implements $ForwardGeocodingResponseCopyWith<$Res> {
  factory _$ForwardGeocodingResponseCopyWith(_ForwardGeocodingResponse value, $Res Function(_ForwardGeocodingResponse) _then) = __$ForwardGeocodingResponseCopyWithImpl;
@override @useResult
$Res call({
 ForwardGeocodingData data
});


@override $ForwardGeocodingDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ForwardGeocodingResponseCopyWithImpl<$Res>
    implements _$ForwardGeocodingResponseCopyWith<$Res> {
  __$ForwardGeocodingResponseCopyWithImpl(this._self, this._then);

  final _ForwardGeocodingResponse _self;
  final $Res Function(_ForwardGeocodingResponse) _then;

/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ForwardGeocodingResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ForwardGeocodingData,
  ));
}

/// Create a copy of ForwardGeocodingResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForwardGeocodingDataCopyWith<$Res> get data {
  
  return $ForwardGeocodingDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ForwardGeocodingData {

 List<FGAddressModel> get results;
/// Create a copy of ForwardGeocodingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForwardGeocodingDataCopyWith<ForwardGeocodingData> get copyWith => _$ForwardGeocodingDataCopyWithImpl<ForwardGeocodingData>(this as ForwardGeocodingData, _$identity);

  /// Serializes this ForwardGeocodingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForwardGeocodingData&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ForwardGeocodingData(results: $results)';
}


}

/// @nodoc
abstract mixin class $ForwardGeocodingDataCopyWith<$Res>  {
  factory $ForwardGeocodingDataCopyWith(ForwardGeocodingData value, $Res Function(ForwardGeocodingData) _then) = _$ForwardGeocodingDataCopyWithImpl;
@useResult
$Res call({
 List<FGAddressModel> results
});




}
/// @nodoc
class _$ForwardGeocodingDataCopyWithImpl<$Res>
    implements $ForwardGeocodingDataCopyWith<$Res> {
  _$ForwardGeocodingDataCopyWithImpl(this._self, this._then);

  final ForwardGeocodingData _self;
  final $Res Function(ForwardGeocodingData) _then;

/// Create a copy of ForwardGeocodingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<FGAddressModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ForwardGeocodingData].
extension ForwardGeocodingDataPatterns on ForwardGeocodingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForwardGeocodingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForwardGeocodingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForwardGeocodingData value)  $default,){
final _that = this;
switch (_that) {
case _ForwardGeocodingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForwardGeocodingData value)?  $default,){
final _that = this;
switch (_that) {
case _ForwardGeocodingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FGAddressModel> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForwardGeocodingData() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FGAddressModel> results)  $default,) {final _that = this;
switch (_that) {
case _ForwardGeocodingData():
return $default(_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FGAddressModel> results)?  $default,) {final _that = this;
switch (_that) {
case _ForwardGeocodingData() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForwardGeocodingData implements ForwardGeocodingData {
  const _ForwardGeocodingData({required final  List<FGAddressModel> results}): _results = results;
  factory _ForwardGeocodingData.fromJson(Map<String, dynamic> json) => _$ForwardGeocodingDataFromJson(json);

 final  List<FGAddressModel> _results;
@override List<FGAddressModel> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ForwardGeocodingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForwardGeocodingDataCopyWith<_ForwardGeocodingData> get copyWith => __$ForwardGeocodingDataCopyWithImpl<_ForwardGeocodingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForwardGeocodingDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForwardGeocodingData&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ForwardGeocodingData(results: $results)';
}


}

/// @nodoc
abstract mixin class _$ForwardGeocodingDataCopyWith<$Res> implements $ForwardGeocodingDataCopyWith<$Res> {
  factory _$ForwardGeocodingDataCopyWith(_ForwardGeocodingData value, $Res Function(_ForwardGeocodingData) _then) = __$ForwardGeocodingDataCopyWithImpl;
@override @useResult
$Res call({
 List<FGAddressModel> results
});




}
/// @nodoc
class __$ForwardGeocodingDataCopyWithImpl<$Res>
    implements _$ForwardGeocodingDataCopyWith<$Res> {
  __$ForwardGeocodingDataCopyWithImpl(this._self, this._then);

  final _ForwardGeocodingData _self;
  final $Res Function(_ForwardGeocodingData) _then;

/// Create a copy of ForwardGeocodingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_ForwardGeocodingData(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<FGAddressModel>,
  ));
}


}


/// @nodoc
mixin _$FGAddressModel {

@JsonKey(name: 'display_name') String get displayName; FGLocationModel get location;
/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FGAddressModelCopyWith<FGAddressModel> get copyWith => _$FGAddressModelCopyWithImpl<FGAddressModel>(this as FGAddressModel, _$identity);

  /// Serializes this FGAddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FGAddressModel&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,location);

@override
String toString() {
  return 'FGAddressModel(displayName: $displayName, location: $location)';
}


}

/// @nodoc
abstract mixin class $FGAddressModelCopyWith<$Res>  {
  factory $FGAddressModelCopyWith(FGAddressModel value, $Res Function(FGAddressModel) _then) = _$FGAddressModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'display_name') String displayName, FGLocationModel location
});


$FGLocationModelCopyWith<$Res> get location;

}
/// @nodoc
class _$FGAddressModelCopyWithImpl<$Res>
    implements $FGAddressModelCopyWith<$Res> {
  _$FGAddressModelCopyWithImpl(this._self, this._then);

  final FGAddressModel _self;
  final $Res Function(FGAddressModel) _then;

/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? location = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as FGLocationModel,
  ));
}
/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FGLocationModelCopyWith<$Res> get location {
  
  return $FGLocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [FGAddressModel].
extension FGAddressModelPatterns on FGAddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FGAddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FGAddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FGAddressModel value)  $default,){
final _that = this;
switch (_that) {
case _FGAddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FGAddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _FGAddressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName,  FGLocationModel location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FGAddressModel() when $default != null:
return $default(_that.displayName,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName,  FGLocationModel location)  $default,) {final _that = this;
switch (_that) {
case _FGAddressModel():
return $default(_that.displayName,_that.location);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'display_name')  String displayName,  FGLocationModel location)?  $default,) {final _that = this;
switch (_that) {
case _FGAddressModel() when $default != null:
return $default(_that.displayName,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FGAddressModel implements FGAddressModel {
  const _FGAddressModel({@JsonKey(name: 'display_name') required this.displayName, required this.location});
  factory _FGAddressModel.fromJson(Map<String, dynamic> json) => _$FGAddressModelFromJson(json);

@override@JsonKey(name: 'display_name') final  String displayName;
@override final  FGLocationModel location;

/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FGAddressModelCopyWith<_FGAddressModel> get copyWith => __$FGAddressModelCopyWithImpl<_FGAddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FGAddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FGAddressModel&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,location);

@override
String toString() {
  return 'FGAddressModel(displayName: $displayName, location: $location)';
}


}

/// @nodoc
abstract mixin class _$FGAddressModelCopyWith<$Res> implements $FGAddressModelCopyWith<$Res> {
  factory _$FGAddressModelCopyWith(_FGAddressModel value, $Res Function(_FGAddressModel) _then) = __$FGAddressModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'display_name') String displayName, FGLocationModel location
});


@override $FGLocationModelCopyWith<$Res> get location;

}
/// @nodoc
class __$FGAddressModelCopyWithImpl<$Res>
    implements _$FGAddressModelCopyWith<$Res> {
  __$FGAddressModelCopyWithImpl(this._self, this._then);

  final _FGAddressModel _self;
  final $Res Function(_FGAddressModel) _then;

/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? location = null,}) {
  return _then(_FGAddressModel(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as FGLocationModel,
  ));
}

/// Create a copy of FGAddressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FGLocationModelCopyWith<$Res> get location {
  
  return $FGLocationModelCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$FGLocationModel {

 double get lat; double get lng;
/// Create a copy of FGLocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FGLocationModelCopyWith<FGLocationModel> get copyWith => _$FGLocationModelCopyWithImpl<FGLocationModel>(this as FGLocationModel, _$identity);

  /// Serializes this FGLocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FGLocationModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'FGLocationModel(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $FGLocationModelCopyWith<$Res>  {
  factory $FGLocationModelCopyWith(FGLocationModel value, $Res Function(FGLocationModel) _then) = _$FGLocationModelCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$FGLocationModelCopyWithImpl<$Res>
    implements $FGLocationModelCopyWith<$Res> {
  _$FGLocationModelCopyWithImpl(this._self, this._then);

  final FGLocationModel _self;
  final $Res Function(FGLocationModel) _then;

/// Create a copy of FGLocationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FGLocationModel].
extension FGLocationModelPatterns on FGLocationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FGLocationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FGLocationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FGLocationModel value)  $default,){
final _that = this;
switch (_that) {
case _FGLocationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FGLocationModel value)?  $default,){
final _that = this;
switch (_that) {
case _FGLocationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FGLocationModel() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _FGLocationModel():
return $default(_that.lat,_that.lng);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _FGLocationModel() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FGLocationModel implements FGLocationModel {
  const _FGLocationModel({required this.lat, required this.lng});
  factory _FGLocationModel.fromJson(Map<String, dynamic> json) => _$FGLocationModelFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of FGLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FGLocationModelCopyWith<_FGLocationModel> get copyWith => __$FGLocationModelCopyWithImpl<_FGLocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FGLocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FGLocationModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'FGLocationModel(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$FGLocationModelCopyWith<$Res> implements $FGLocationModelCopyWith<$Res> {
  factory _$FGLocationModelCopyWith(_FGLocationModel value, $Res Function(_FGLocationModel) _then) = __$FGLocationModelCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$FGLocationModelCopyWithImpl<$Res>
    implements _$FGLocationModelCopyWith<$Res> {
  __$FGLocationModelCopyWithImpl(this._self, this._then);

  final _FGLocationModel _self;
  final $Res Function(_FGLocationModel) _then;

/// Create a copy of FGLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_FGLocationModel(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
