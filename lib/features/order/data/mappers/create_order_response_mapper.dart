import '../../domain/entities/create_order_response.dart';
import '../models/create_order_response_model.dart';
import 'order_mapper.dart';

extension CreateOrderResponseMapper on CreateOrderResponseModel {
  CreateOrderResponse toDomain() =>
      CreateOrderResponse(receiveCode: receiveCode, order: order.toDomain());
}
