// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_order_payment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryOrderPaymentResponse {

 String get status; String? get method;@JsonKey(fromJson: parseDoubleNullable) double? get amount; String? get transId; String? get transTime;
/// Create a copy of QueryOrderPaymentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryOrderPaymentResponseCopyWith<QueryOrderPaymentResponse> get copyWith => _$QueryOrderPaymentResponseCopyWithImpl<QueryOrderPaymentResponse>(this as QueryOrderPaymentResponse, _$identity);

  /// Serializes this QueryOrderPaymentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryOrderPaymentResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transId, transId) || other.transId == transId)&&(identical(other.transTime, transTime) || other.transTime == transTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,method,amount,transId,transTime);

@override
String toString() {
  return 'QueryOrderPaymentResponse(status: $status, method: $method, amount: $amount, transId: $transId, transTime: $transTime)';
}


}

/// @nodoc
abstract mixin class $QueryOrderPaymentResponseCopyWith<$Res>  {
  factory $QueryOrderPaymentResponseCopyWith(QueryOrderPaymentResponse value, $Res Function(QueryOrderPaymentResponse) _then) = _$QueryOrderPaymentResponseCopyWithImpl;
@useResult
$Res call({
 String status, String? method,@JsonKey(fromJson: parseDoubleNullable) double? amount, String? transId, String? transTime
});




}
/// @nodoc
class _$QueryOrderPaymentResponseCopyWithImpl<$Res>
    implements $QueryOrderPaymentResponseCopyWith<$Res> {
  _$QueryOrderPaymentResponseCopyWithImpl(this._self, this._then);

  final QueryOrderPaymentResponse _self;
  final $Res Function(QueryOrderPaymentResponse) _then;

/// Create a copy of QueryOrderPaymentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? method = freezed,Object? amount = freezed,Object? transId = freezed,Object? transTime = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transId: freezed == transId ? _self.transId : transId // ignore: cast_nullable_to_non_nullable
as String?,transTime: freezed == transTime ? _self.transTime : transTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryOrderPaymentResponse].
extension QueryOrderPaymentResponsePatterns on QueryOrderPaymentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueryOrderPaymentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueryOrderPaymentResponse value)  $default,){
final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueryOrderPaymentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? method, @JsonKey(fromJson: parseDoubleNullable)  double? amount,  String? transId,  String? transTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse() when $default != null:
return $default(_that.status,_that.method,_that.amount,_that.transId,_that.transTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? method, @JsonKey(fromJson: parseDoubleNullable)  double? amount,  String? transId,  String? transTime)  $default,) {final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse():
return $default(_that.status,_that.method,_that.amount,_that.transId,_that.transTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? method, @JsonKey(fromJson: parseDoubleNullable)  double? amount,  String? transId,  String? transTime)?  $default,) {final _that = this;
switch (_that) {
case _QueryOrderPaymentResponse() when $default != null:
return $default(_that.status,_that.method,_that.amount,_that.transId,_that.transTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueryOrderPaymentResponse extends QueryOrderPaymentResponse {
  const _QueryOrderPaymentResponse({required this.status, this.method, @JsonKey(fromJson: parseDoubleNullable) this.amount, this.transId, this.transTime}): super._();
  factory _QueryOrderPaymentResponse.fromJson(Map<String, dynamic> json) => _$QueryOrderPaymentResponseFromJson(json);

@override final  String status;
@override final  String? method;
@override@JsonKey(fromJson: parseDoubleNullable) final  double? amount;
@override final  String? transId;
@override final  String? transTime;

/// Create a copy of QueryOrderPaymentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueryOrderPaymentResponseCopyWith<_QueryOrderPaymentResponse> get copyWith => __$QueryOrderPaymentResponseCopyWithImpl<_QueryOrderPaymentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueryOrderPaymentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueryOrderPaymentResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transId, transId) || other.transId == transId)&&(identical(other.transTime, transTime) || other.transTime == transTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,method,amount,transId,transTime);

@override
String toString() {
  return 'QueryOrderPaymentResponse(status: $status, method: $method, amount: $amount, transId: $transId, transTime: $transTime)';
}


}

/// @nodoc
abstract mixin class _$QueryOrderPaymentResponseCopyWith<$Res> implements $QueryOrderPaymentResponseCopyWith<$Res> {
  factory _$QueryOrderPaymentResponseCopyWith(_QueryOrderPaymentResponse value, $Res Function(_QueryOrderPaymentResponse) _then) = __$QueryOrderPaymentResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String? method,@JsonKey(fromJson: parseDoubleNullable) double? amount, String? transId, String? transTime
});




}
/// @nodoc
class __$QueryOrderPaymentResponseCopyWithImpl<$Res>
    implements _$QueryOrderPaymentResponseCopyWith<$Res> {
  __$QueryOrderPaymentResponseCopyWithImpl(this._self, this._then);

  final _QueryOrderPaymentResponse _self;
  final $Res Function(_QueryOrderPaymentResponse) _then;

/// Create a copy of QueryOrderPaymentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? method = freezed,Object? amount = freezed,Object? transId = freezed,Object? transTime = freezed,}) {
  return _then(_QueryOrderPaymentResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transId: freezed == transId ? _self.transId : transId // ignore: cast_nullable_to_non_nullable
as String?,transTime: freezed == transTime ? _self.transTime : transTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
