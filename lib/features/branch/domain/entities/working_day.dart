import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_day.freezed.dart';

/// Working day entity representing a day of the week and its active status.
@freezed
sealed class WorkingDay with _$WorkingDay {
  const factory WorkingDay({required String label, required bool value}) =
      _WorkingDay;
}
