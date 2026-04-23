import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_address_model.dart';
import 'order_branch_model.dart';
import 'order_item_model.dart';
import 'order_model.dart';
import 'payment_model.dart';

part 'order_detail_model.freezed.dart';
part 'order_detail_model.g.dart';

@freezed
sealed class OrderDetailModel with _$OrderDetailModel {
  const OrderDetailModel._();

  const factory OrderDetailModel({
    required OrderModel order,
    required List<OrderItemModel> items,
    OrderAddressModel?
    address, // Nullable because pickup orders don't have addresses
    required PaymentModel payment,
    OrderBranchModel? branch,
  }) = _OrderDetailModel;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);
}
