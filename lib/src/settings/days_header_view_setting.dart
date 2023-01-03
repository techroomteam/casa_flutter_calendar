import 'dart:ui';

class DaysHeaderViewSetting {
  final int numberOfDays;

  /// this should be in ['Sun', 'Mon', ..] formate
  final List<String> activeDaysList;

  /// this is active day container background color
  final Color activeDayColor;

  /// this is active day container background color
  final Color inActiveDayColor;

  /// this is active day container background color
  final Color activeViewTextColor;
  final Color inActiveViewTextColor;
  final Color disableDayViewTextColor;

  final bool showNotificationCounter;

  final double headerHeight;

  /// Should pass any kind of height from top, for example statusBar, appBar etc
  final double extraHeight;

  const DaysHeaderViewSetting({
    this.numberOfDays = 7,
    this.activeDaysList = const [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ],
    this.headerHeight = 110.0,
    this.extraHeight = 0.0,
    this.showNotificationCounter = false,
    this.activeDayColor = const Color(0xff7B4CEB),
    this.inActiveDayColor = const Color(0xff3C4549),
    this.activeViewTextColor = const Color(0xffFFFFFF),
    this.inActiveViewTextColor = const Color(0xff3C4549),
    this.disableDayViewTextColor = const Color(0xffD2D5DF),
  });
}
