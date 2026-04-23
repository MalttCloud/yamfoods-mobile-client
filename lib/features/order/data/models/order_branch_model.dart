import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_branch_model.freezed.dart';
part 'order_branch_model.g.dart';

@freezed
sealed class OrderBranchModel with _$OrderBranchModel {
  const factory OrderBranchModel({
    required String name,
    required String address,
    required String contactPhone,
  }) = _OrderBranchModel;

  factory OrderBranchModel.fromJson(Map<String, dynamic> json) =>
      _$OrderBranchModelFromJson(json);
}