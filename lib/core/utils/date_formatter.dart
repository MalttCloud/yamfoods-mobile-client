/// Utility class for formatting dates in a user-friendly format.
class DateFormatter {
  DateFormatter._();

  /// Formats a date range (start and end dates) in a readable format.
  ///
  /// Examples:
  /// - "Dec 22 - Jan 5, 2025" (different months, same year)
  /// - "Dec 22 - 31, 2024" (same month, same year)
  /// - "Dec 22, 2024 - Jan 5, 2025" (different years)
  ///
  /// [startDate] - The start date of the range
  /// [endDate] - The end date of the range
  ///
  /// Returns a formatted date range string.
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    final startMonth = _getMonthAbbreviation(startDate.month);
    final endMonth = _getMonthAbbreviation(endDate.month);
    final startDay = startDate.day;
    final endDay = endDate.day;
    final startYear = startDate.year;
    final endYear = endDate.year;

    // Same year
    if (startYear == endYear) {
      // Same month
      if (startDate.month == endDate.month) {
        return '$startMonth $startDay - $endDay, $startYear';
      } else {
        // Different months, same year
        return '$startMonth $startDay - $endMonth $endDay, $startYear';
      }
    } else {
      // Different years
      return '$startMonth $startDay, $startYear - $endMonth $endDay, $endYear';
    }
  }

  /// Formats DateTime to "time ago" string (e.g., "2 days ago", "1 hour ago").
  ///
  /// Examples:
  /// - "2 days ago"
  /// - "1 hour ago"
  /// - "Just now"
  ///
  /// [dateTime] - The date to format relative to now
  ///
  /// Returns a formatted "time ago" string.
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a date for transaction history display.
  ///
  /// Uses local time. Recent same-calendar-day entries are relative; older
  /// entries use [May-15-2026] style.
  ///
  /// Examples:
  /// - "Just now"
  /// - "5 mins ago"
  /// - "2 hrs ago"
  /// - "Yesterday"
  /// - "May-15-2026"
  static String formatTransactionDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(local);

    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(local.year, local.month, local.day);
    final calendarDaysAgo = today.difference(dateDay).inDays;

    if (calendarDaysAgo == 0) {
      if (difference.inMinutes < 1) {
        return 'Just now';
      }
      if (difference.inHours < 1) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
      }
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hr' : 'hrs'} ago';
    }

    if (calendarDaysAgo == 1) {
      return 'Yesterday';
    }

    final month = _getMonthAbbreviation(local.month);
    final day = local.day.toString().padLeft(2, '0');
    return '$month-$day-${local.year}';
  }

  /// Gets the abbreviated month name.
  static String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
