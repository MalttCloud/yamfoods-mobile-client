import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code.freezed.dart';

@freezed
sealed class PromoCode with _$PromoCode {
  const factory PromoCode({
    required int id,
    required String code,
    required String discount,
    required int minOrderQty,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PromoCode;
}
