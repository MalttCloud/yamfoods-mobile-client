// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
sealed class AddressModel with _$AddressModel {
  const factory AddressModel({
    required int id,
    required int userId,
    required String address,
    String? receiverPhone,
    String? receiverName,
    String? label,
    required String lat,
    required String lng,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}
