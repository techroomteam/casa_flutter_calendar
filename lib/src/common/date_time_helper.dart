// ignore: avoid_classes_with_only_static_members
/// Holds the static helper methods used for date calculation in calendar.
class DateTimeHelper {
  /// Returns the list of current month dates alone from the dates passed.
  static List<DateTime> getCurrentMonthDates(List<DateTime> visibleDates) {
    final int visibleDatesCount = visibleDates.length;
    final int currentMonth = visibleDates[visibleDatesCount ~/ 2].month;
    final List<DateTime> currentMonthDates = <DateTime>[];
    for (int i = 0; i < visibleDatesCount; i++) {
      final DateTime currentVisibleDate = visibleDates[i];
      if (currentVisibleDate.month != currentMonth) {
        continue;
      }

      currentMonthDates.add(currentVisibleDate);
    }

    return currentMonthDates;
  }

  /// Get the weeks in year
  static int getWeeksInYear(int year) {
    int P(int y) => (y + (y ~/ 4) - (y ~/ 100) + (y ~/ 400)) % 7;
    if (P(year) == 4 || P(year - 1) == 3) {
      return 53;
    }
    return 52;
  }
}
