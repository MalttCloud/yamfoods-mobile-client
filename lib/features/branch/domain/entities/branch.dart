import 'package:freezed_annotation/freezed_annotation.dart';

import 'working_day.dart';

part 'branch.freezed.dart';

/// Branch entity representing a restaurant branch location.
///
/// Location is stored as a record type with latitude and longitude.
@freezed
sealed class Branch with _$Branch {
  const factory Branch({
    required int id,
    required String name,
    required ({double lat, double lng}) location,
    required String address,
    required bool isActive,
    required String contactPhone,
    required String openingHour,
    required String closingHour,
    required List<WorkingDay> activeWorkingDays,
    required DateTime launchDate,
    required DateTime createdDate,
    required DateTime lastUpdateDate,
    required int createdBy,
  }) = _Branch;
}
