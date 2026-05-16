// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AchievementTransactionModel {

 int get id;@JsonKey(name: 'userId') int get userId; String get type; String? get achievmentType; int get points;@JsonKey(name: 'relatedUserId') int? get relatedUserId;@JsonKey(name: 'relatedUserPhone') String? get relatedUserPhone;@JsonKey(name: 'referenceId') int? get referenceId; String? get description;@JsonKey(name: 'createdAt') DateTime get createdAt;
/// Create a copy of AchievementTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementTransactionModelCopyWith<AchievementTransactionModel> get copyWith => _$AchievementTransactionModelCopyWithImpl<AchievementTransactionModel>(this as AchievementTransactionModel, _$identity);

  /// Serializes this AchievementTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AchievementTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.achievmentType, achievmentType) || other.achievmentType == achievmentType)&&(identical(other.points, points) || other.points == points)&&(identical(other.relatedUserId, relatedUserId) || other.relatedUserId == relatedUserId)&&(identical(other.relatedUserPhone, relatedUserPhone) || other.relatedUserPhone == relatedUserPhone)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,achievmentType,points,relatedUserId,relatedUserPhone,referenceId,description,createdAt);

@override
String toString() {
  return 'AchievementTransactionModel(id: $id, userId: $userId, type: $type, achievmentType: $achievmentType, points: $points, relatedUserId: $relatedUserId, relatedUserPhone: $relatedUserPhone, referenceId: $referenceId, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AchievementTransactionModelCopyWith<$Res>  {
  factory $AchievementTransactionModelCopyWith(AchievementTransactionModel value, $Res Function(AchievementTransactionModel) _then) = _$AchievementTransactionModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'userId') int userId, String type, String? achievmentType, int points,@JsonKey(name: 'relatedUserId') int? relatedUserId,@JsonKey(name: 'relatedUserPhone') String? relatedUserPhone,@JsonKey(name: 'referenceId') int? referenceId, String? description,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class _$AchievementTransactionModelCopyWithImpl<$Res>
    implements $AchievementTransactionModelCopyWith<$Res> {
  _$AchievementTransactionModelCopyWithImpl(this._self, this._then);

  final AchievementTransactionModel _self;
  final $Res Function(AchievementTransactionModel) _then;

/// Create a copy of AchievementTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? achievmentType = freezed,Object? points = null,Object? relatedUserId = freezed,Object? relatedUserPhone = freezed,Object? referenceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,achievmentType: freezed == achievmentType ? _self.achievmentType : achievmentType // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,relatedUserId: freezed == relatedUserId ? _self.relatedUserId : relatedUserId // ignore: cast_nullable_to_non_nullable
as int?,relatedUserPhone: freezed == relatedUserPhone ? _self.relatedUserPhone : relatedUserPhone // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AchievementTransactionModel].
extension AchievementTransactionModelPatterns on AchievementTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AchievementTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AchievementTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AchievementTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _AchievementTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AchievementTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _AchievementTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'userId')  int userId,  String type,  String? achievmentType,  int points, @JsonKey(name: 'relatedUserId')  int? relatedUserId, @JsonKey(name: 'relatedUserPhone')  String? relatedUserPhone, @JsonKey(name: 'referenceId')  int? referenceId,  String? description, @JsonKey(name: 'createdAt')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AchievementTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.achievmentType,_that.points,_that.relatedUserId,_that.relatedUserPhone,_that.referenceId,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'userId')  int userId,  String type,  String? achievmentType,  int points, @JsonKey(name: 'relatedUserId')  int? relatedUserId, @JsonKey(name: 'relatedUserPhone')  String? relatedUserPhone, @JsonKey(name: 'referenceId')  int? referenceId,  String? description, @JsonKey(name: 'createdAt')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AchievementTransactionModel():
return $default(_that.id,_that.userId,_that.type,_that.achievmentType,_that.points,_that.relatedUserId,_that.relatedUserPhone,_that.referenceId,_that.description,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'userId')  int userId,  String type,  String? achievmentType,  int points, @JsonKey(name: 'relatedUserId')  int? relatedUserId, @JsonKey(name: 'relatedUserPhone')  String? relatedUserPhone, @JsonKey(name: 'referenceId')  int? referenceId,  String? description, @JsonKey(name: 'createdAt')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AchievementTransactionModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.achievmentType,_that.points,_that.relatedUserId,_that.relatedUserPhone,_that.referenceId,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AchievementTransactionModel implements AchievementTransactionModel {
  const _AchievementTransactionModel({required this.id, @JsonKey(name: 'userId') required this.userId, required this.type, this.achievmentType, required this.points, @JsonKey(name: 'relatedUserId') this.relatedUserId, @JsonKey(name: 'relatedUserPhone') this.relatedUserPhone, @JsonKey(name: 'referenceId') this.referenceId, this.description, @JsonKey(name: 'createdAt') required this.createdAt});
  factory _AchievementTransactionModel.fromJson(Map<String, dynamic> json) => _$AchievementTransactionModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'userId') final  int userId;
@override final  String type;
@override final  String? achievmentType;
@override final  int points;
@override@JsonKey(name: 'relatedUserId') final  int? relatedUserId;
@override@JsonKey(name: 'relatedUserPhone') final  String? relatedUserPhone;
@override@JsonKey(name: 'referenceId') final  int? referenceId;
@override final  String? description;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;

/// Create a copy of AchievementTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementTransactionModelCopyWith<_AchievementTransactionModel> get copyWith => __$AchievementTransactionModelCopyWithImpl<_AchievementTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AchievementTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AchievementTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.achievmentType, achievmentType) || other.achievmentType == achievmentType)&&(identical(other.points, points) || other.points == points)&&(identical(other.relatedUserId, relatedUserId) || other.relatedUserId == relatedUserId)&&(identical(other.relatedUserPhone, relatedUserPhone) || other.relatedUserPhone == relatedUserPhone)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,achievmentType,points,relatedUserId,relatedUserPhone,referenceId,description,createdAt);

@override
String toString() {
  return 'AchievementTransactionModel(id: $id, userId: $userId, type: $type, achievmentType: $achievmentType, points: $points, relatedUserId: $relatedUserId, relatedUserPhone: $relatedUserPhone, referenceId: $referenceId, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AchievementTransactionModelCopyWith<$Res> implements $AchievementTransactionModelCopyWith<$Res> {
  factory _$AchievementTransactionModelCopyWith(_AchievementTransactionModel value, $Res Function(_AchievementTransactionModel) _then) = __$AchievementTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'userId') int userId, String type, String? achievmentType, int points,@JsonKey(name: 'relatedUserId') int? relatedUserId,@JsonKey(name: 'relatedUserPhone') String? relatedUserPhone,@JsonKey(name: 'referenceId') int? referenceId, String? description,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class __$AchievementTransactionModelCopyWithImpl<$Res>
    implements _$AchievementTransactionModelCopyWith<$Res> {
  __$AchievementTransactionModelCopyWithImpl(this._self, this._then);

  final _AchievementTransactionModel _self;
  final $Res Function(_AchievementTransactionModel) _then;

/// Create a copy of AchievementTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? achievmentType = freezed,Object? points = null,Object? relatedUserId = freezed,Object? relatedUserPhone = freezed,Object? referenceId = freezed,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_AchievementTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,achievmentType: freezed == achievmentType ? _self.achievmentType : achievmentType // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,relatedUserId: freezed == relatedUserId ? _self.relatedUserId : relatedUserId // ignore: cast_nullable_to_non_nullable
as int?,relatedUserPhone: freezed == relatedUserPhone ? _self.relatedUserPhone : relatedUserPhone // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
