import 'package:flutter/material.dart';

import '../entities/branch.dart';

/// Extension methods for [Branch] entity.
extension BranchExtensions on Branch {
  /// Checks if the branch is currently open based on:
  /// - Current day is in active working days
  /// - Current time is between opening and closing hours
  ///
  /// Returns `true` if branch is open, `false` otherwise.
  bool get isCurrentlyOpen {
    final now = DateTime.now();
    final currentDayName = _getDayName(now.weekday);

    // Check if today is an active working day
    final isWorkingDay = activeWorkingDays.any(
      (day) =>
          day.label.toLowerCase() == currentDayName.toLowerCase() && day.value,
    );

    if (!isWorkingDay) {
      return false;
    }

    // Parse opening and closing hours
    final openingTime = _parseTime(openingHour);
    final closingTime = _parseTime(closingHour);

    if (openingTime == null || closingTime == null) {
      return false;
    }

    final currentTime = TimeOfDay.fromDateTime(now);

    // Handle case where closing time is after midnight (e.g., 02:00)
    if (closingTime.hour < openingTime.hour) {
      // Closing time is next day
      final isAfterOpening =
          currentTime.hour > openingTime.hour ||
          (currentTime.hour == openingTime.hour &&
              currentTime.minute >= openingTime.minute);
      final isBeforeClosing =
          currentTime.hour < closingTime.hour ||
          (currentTime.hour == closingTime.hour &&
              currentTime.minute < closingTime.minute);
      return isAfterOpening || isBeforeClosing;
    } else {
      // Normal case: opening and closing on same day
      final isAfterOpening =
          currentTime.hour > openingTime.hour ||
          (currentTime.hour == openingTime.hour &&
              currentTime.minute >= openingTime.minute);
      final isBeforeClosing =
          currentTime.hour < closingTime.hour ||
          (currentTime.hour == closingTime.hour &&
              currentTime.minute < closingTime.minute);
      return isAfterOpening && isBeforeClosing;
    }
  }

  /// Converts weekday number (1-7, Monday=1) to day name.
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  /// Parses time string in format "HH:MM:SS" or "HH:MM" to [TimeOfDay].
  ///
  /// Returns `null` if parsing fails.
  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) {
        return null;
      }

      final hour = int.parse(parts[0].trim());
      final minute = int.parse(parts[1].trim());

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}
