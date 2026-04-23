import '../../domain/entities/order_detail.dart';
import '../models/order_detail_model.dart';
import 'order_address_mapper.dart';
import 'order_branch_mapper.dart';
import 'order_item_mapper.dart';
import 'payment_mapper.dart';
import 'order_mapper.dart';

extension OrderDetailMapper on OrderDetailModel {
  OrderDetail toDomain() => OrderDetail(
    order: order.toDomain(),
    items: items.map((item) => item.toDomain()).toList(),
    address: address?.toDomain(), // Handle null address for pickup orders
    payment: payment.toDomain(),
    branch: branch?.toDomain(),
  );
}
