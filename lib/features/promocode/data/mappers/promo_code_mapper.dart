import '../../domain/entities/promo_code.dart';
import '../../domain/entities/promo_code_verification_result.dart';
import '../models/promo_code_model.dart';
import '../models/promo_code_verification_result_model.dart';

extension PromoCodeModelMapper on PromoCodeModel {
  /// Converts data model to domain entity.
  PromoCode toDomain() {
    return PromoCode(
      id: id,
      code: code,
      discount: discount,
      minOrderQty: minOrderQty,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension PromoCodeVerificationResultModelMapper
    on PromoCodeVerificationResultModel {
  /// Converts data model to domain entity.
  PromoCodeVerificationResult toDomain() {
    return PromoCodeVerificationResult(
      isValid: isValid,
      discount: discount,
      promo: promo.toDomain(),
    );
  }
}
