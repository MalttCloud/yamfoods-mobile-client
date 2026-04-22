import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_branch.freezed.dart';

@freezed
sealed class OrderBranch with _$OrderBranch {
  const factory OrderBranch({
    required String name,
    required String address,
    required String contactPhone,
  }) = _OrderBranch;

}