import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_location.dart';

part 'order.freezed.dart';

@freezed
sealed class Orderr with _$Orderr {
  //we do Orderr as double rr because dartz package have class called Order to avoid bug we do this
  const factory Orderr({
    required int id,
    required String orderReference,
    int? userId, //this field is not needed but it does not affect
    required String userPhone,
    required int branchId,
    required String qrCode,
    required String status,
    required String type,
    int?
    delivererId, // here it is nullable because this order class intended for customer not for deliverer. for deliverer it should be required, there value is known after the order is assigned to a deliverer
    String? delivererPhone,
    DateTime? scheduledAt,
    String? note,
    String? tableNumber,
    required int quantity,
    required double subtotal,
    double? vatTotal,
    required double deliveryFee,
    int? pointUsed,
    double? pointDiscount,
    String? promoCode,
    double? promoCodeDiscount,
    double? discountTotal,
    required double totalAmount,
    required OrderLocation branchLocation,
    required OrderLocation deliveryLocation,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Orderr;
}


//get all orders
//get order detail
//get pending orders
//get completed orders
//get cancelled orders
//get pending orders count
//get completed orders count
//get total orders count