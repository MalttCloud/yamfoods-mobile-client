import '../../domain/entities/app_configuration.dart';
import '../models/app_configuration_model.dart';
import 'app_version_mapper.dart';

extension AppConfigurationMapper on AppConfigurationModel {
  AppConfiguration toDomain() {
    return AppConfiguration(
      id: id,
      pointConversionRate: pointConversionRate,
      minimumPointsRedemption: minimumPointsRedemption,
      maxCartItems: maxCartItems,
      maxQuantityPerItem: maxQuantityPerItem,
      deliveryFeePerKm: deliveryFeePerKm,
      deliveryStartFee: deliveryStartFee,
      maxOrderSchedulingDays: maxOrderSchedulingDays,
      createdAt: createdAt,
      updatedAt: updatedAt,
      appVersion: appVersion.toDomain(),
    );
  }
}
