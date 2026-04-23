import '../../domain/entities/order_item.dart';
import '../models/order_item_model.dart';

extension OrderItemMapper on OrderItemModel {
  OrderItem toDomain() => OrderItem(
    id: id,
    orderId: orderId,
    productId: productId,
    quantity: quantity,
    name: name,
    price: price,
    images: images,
    description: description,
    ingredients: ingredients,
    discount: discount,
    variants: variants,
    nutrition: nutrition,
    vatRate: vatRate,
    createdAt: createdAt,
  );
}
