// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'branch_model.dart';

part 'branches_response_model.freezed.dart';
part 'branches_response_model.g.dart';

/// Response model for branches list API.
///
/// Wraps the branches array from the API response data.
@freezed
sealed class BranchesResponseModel with _$BranchesResponseModel {
  const factory BranchesResponseModel({required List<BranchModel> branches}) =
      _BranchesResponseModel;

  factory BranchesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BranchesResponseModelFromJson(json);
}
