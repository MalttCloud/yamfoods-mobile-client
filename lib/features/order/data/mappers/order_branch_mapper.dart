import '../../domain/entities/order_branch.dart';
import '../models/order_branch_model.dart';

extension OrderBranchMapper on OrderBranchModel {
  OrderBranch toDomain() => OrderBranch(
    name: name,
    address: address,
    contactPhone: contactPhone,
  );
}