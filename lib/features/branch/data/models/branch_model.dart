// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'working_day_model.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

/// Branch model for JSON serialization.
///
/// Location is stored as String in the model (as received from API)
/// and will be parsed to structured type in the mapper.
@freezed
sealed class BranchModel with _$BranchModel {
  const factory BranchModel({
    required int id,
    required String name,
    required String location, // Will be parsed in mapper
    required String address,
    @JsonKey(name: 'isActive') required int isActive, // API returns 1/0
    @JsonKey(name: 'contactPhone') required String contactPhone,
    @JsonKey(name: 'openingHour') required String openingHour,
    @JsonKey(name: 'closingHour') required String closingHour,
    @JsonKey(name: 'activeWorkingDays')
    required List<WorkingDayModel> activeWorkingDays,
    @JsonKey(name: 'launchDate') required DateTime launchDate,
    @JsonKey(name: 'createdDate') required DateTime createdDate,
    @JsonKey(name: 'lastUpdateDate') required DateTime lastUpdateDate,
    @JsonKey(name: 'createdBy') required int createdBy,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);
}
