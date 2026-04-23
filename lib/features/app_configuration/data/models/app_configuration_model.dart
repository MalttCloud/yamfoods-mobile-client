// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';
import 'app_version_model.dart';

part 'app_configuration_model.freezed.dart';
part 'app_configuration_model.g.dart';

@freezed
sealed class AppConfigurationModel with _$AppConfigurationModel {
  const AppConfigurationModel._();

  const factory AppConfigurationModel({
    required int id,
    @JsonKey(fromJson: parseDouble) required double pointConversionRate,
    required int minimumPointsRedemption,
    required int maxCartItems,
    required int maxQuantityPerItem,
    @JsonKey(fromJson: parseDouble) required double deliveryFeePerKm,
    @JsonKey(fromJson: parseDouble) required double deliveryStartFee,
    required int maxOrderSchedulingDays,
    required DateTime createdAt,
    required DateTime updatedAt,
    required AppVersionModel appVersion,
  }) = _AppConfigurationModel;

  factory AppConfigurationModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigurationModelFromJson(json);
}
