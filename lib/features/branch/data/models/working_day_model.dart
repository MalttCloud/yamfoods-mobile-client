// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_day_model.freezed.dart';
part 'working_day_model.g.dart';

/// Working day model for JSON serialization.
@freezed
sealed class WorkingDayModel with _$WorkingDayModel {
  const factory WorkingDayModel({required String label, required bool value}) =
      _WorkingDayModel;

  factory WorkingDayModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingDayModelFromJson(json);
}
