import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/domain/entities/product.dart';

part 'cart.freezed.dart';

@freezed
sealed class Cart with _$Cart {
  const factory Cart({
    required int id,
    required int userId,
    required int productId,
    required int quantity,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Product product,
  }) = _Cart;
}
