import '../../domain/entities/order.dart';
import '../models/order_model.dart';
import 'order_location_mapper.dart';

extension OrderMapper on OrderModel {
  Orderr toDomain() => Orderr(
    id: id,
    orderReference: orderReference,
    userId: userId,
    userPhone: userPhone,
    branchId: branchId,
    qrCode: qrCode,
    status: status,
    type: type,
    delivererId: delivererId,
    delivererPhone: delivererPhone,
    scheduledAt: scheduledAt,
    note: note,
    tableNumber: tableNumber,
    quantity: quantity,
    subtotal: subtotal,
    vatTotal: vatTotal,
    deliveryFee: deliveryFee,
    pointUsed: pointUsed,
    pointDiscount: pointDiscount,
    promoCode: promoCode,
    promoCodeDiscount: promoCodeDiscount,
    discountTotal: discountTotal,
    totalAmount: totalAmount,
    branchLocation: branchLocation.toDomain(),
    deliveryLocation: deliveryLocation.toDomain(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
