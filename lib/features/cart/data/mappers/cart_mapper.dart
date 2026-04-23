import '../../domain/entities/cart.dart';
import '../models/cart_model.dart';
import '../../../product/data/mappers/product_mapper.dart';

extension CartModelMapper on CartModel {
  Cart toDomain() {
    return Cart(
      id: id,
      userId: userId,
      productId: productId,
      quantity: quantity,
      createdAt: createdAt,
      updatedAt: updatedAt,
      product: product.toDomain(),
    );
  }
}
