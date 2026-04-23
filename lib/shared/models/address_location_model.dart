// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';

part 'address_location_model.freezed.dart';
part 'address_location_model.g.dart';

@freezed
sealed class AddressLocationModel with _$AddressLocationModel {

  const factory AddressLocationModel({ @JsonKey(fromJson: parseDouble)  required double latitude, @JsonKey(fromJson: parseDouble)  required double longitude}) =
      _AddressLocationModel;

  factory AddressLocationModel.fromJson(Map<String, dynamic> json) =>
      _$AddressLocationModelFromJson(json);

 const AddressLocationModel._();

}
