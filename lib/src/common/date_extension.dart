extension DateTimeExtension on DateTime {
  DateTime next2(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }

  DateTime next(int day) {
    if (day == weekday) {
      return add(const Duration(days: 7));
    } else {
      return add(
        Duration(
          days: (day - weekday) % DateTime.daysPerWeek,
        ),
      );
    }
  }

  // week day Name...
  String? weekdayName() {
    const Map<int, String> weekdayName = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thu",
      5: "Fri",
      6: "Sat",
      7: "Sun"
    };
    return weekdayName[weekday];
  }

  DateTime dateToYMDTime() {
    return DateTime(year, month, day);
  }

  // date to YMD...
  String dateToYMDString() {
    return '$year-${month <= 9 ? '0$month' : month.toString()}-${day <= 9 ? '0$day' : day.toString()}';
  }
}
