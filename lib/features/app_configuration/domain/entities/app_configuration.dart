import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_version.dart';

part 'app_configuration.freezed.dart';

@freezed
sealed class AppConfiguration with _$AppConfiguration {
  const factory AppConfiguration({
    required int id,
    required double pointConversionRate,
    required int minimumPointsRedemption,
    required int maxCartItems,
    required int maxQuantityPerItem,
    required double deliveryFeePerKm,
    required double deliveryStartFee,
    required int maxOrderSchedulingDays,
    required DateTime createdAt,
    required DateTime updatedAt,
    required AppVersion appVersion,
  }) = _AppConfiguration;
}
