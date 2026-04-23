import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';

@freezed
sealed class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required int orderId,
    int? productId,   // product will be deleted but order history is preserved sp that it will be null
    required int quantity,
    required String name,
    required double price,
    required List<String> images,
    String? description,
    List<String>? ingredients,
     String? discount,
    String? variants,
    String? nutrition,
     double? vatRate,
    required DateTime createdAt,
  }) = _OrderItem;


}
