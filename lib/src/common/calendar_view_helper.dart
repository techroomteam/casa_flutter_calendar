import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/model/calendar_appointment.dart';
import 'package:casa_flutter_calendar/src/settings/time_slot_view_setting.dart';
import 'package:flutter/material.dart';

class CalendarViewHelper {
  static double getTimeSlotCount(TimeSlotViewSettings settings) {
    double defaultLinesCount = 24;
    double totalMinutes = 0;
    final int timeInterval = getTimeInterval(settings);

    if (settings.startHour >= 0 &&
        settings.endHour >= settings.startHour &&
        settings.endHour <= 24) {
      defaultLinesCount = settings.endHour - settings.startHour;
    }

    totalMinutes = defaultLinesCount * 60;

    return totalMinutes / timeInterval;
  }

  /// Returns the time interval value based on the given start time, end time
  /// and time interval value of time slot view settings, the time interval will
  /// be auto adjust if the given time interval doesn't cover the given start
  /// and end time values, i.e: if the startHour set as 10 and endHour set as
  /// 20 and the timeInterval value given as 180 means we cannot divide the 10
  /// hours into 3  hours, hence the time interval will be auto adjusted to 200
  /// based on the given properties.
  static int getTimeInterval(TimeSlotViewSettings settings) {
    double defaultLinesCount = 24;
    double totalMinutes = 0;

    if (settings.startHour >= 0 &&
        settings.endHour >= settings.startHour &&
        settings.endHour <= 24) {
      defaultLinesCount = settings.endHour - settings.startHour;
    }

    totalMinutes = defaultLinesCount * 60;

    final int timeIntervalMinutes = settings.timeInterval.inMinutes;
    if (timeIntervalMinutes >= 0 &&
        timeIntervalMinutes <= totalMinutes &&
        totalMinutes.round() % timeIntervalMinutes == 0) {
      return timeIntervalMinutes;
    } else if (timeIntervalMinutes >= 0 &&
        timeIntervalMinutes <= totalMinutes) {
      return _getNearestValue(timeIntervalMinutes, totalMinutes);
    } else {
      return 60;
    }
  }

  static int _getNearestValue(int timeInterval, double totalMinutes) {
    timeInterval++;
    if (totalMinutes.round() % timeInterval == 0) {
      return timeInterval;
    }

    return _getNearestValue(timeInterval, totalMinutes);
  }

  ///
  static double getAppointmentPositionAtTimeSlotFromStartTime(
      DateTime startTime, double timeIntervalHeight) {
    return startTime.hour * timeIntervalHeight;
  }

  // static double convertDroppedOffsetToDateTime() {}

  static double getAppointmentPositionAtTimeSlotFromOffset(
      Offset offset, double scrollOffset, double extraHeight) {
    return (offset.dy + scrollOffset - extraHeight);
  }

  /// Convert Dropped Offset to Time
  // /// This method is helpful when we place an appoitment on [TimeSlotView]
  static double getAppointmentTimeFromTimeSlot(
      Offset offset, double scrollOffset, double timeIntervalHeight) {
    return (offset.dy + scrollOffset) / timeIntervalHeight;
  }

  ///
  static bool isTimeSlotInAvailableArea(DateTime dateTime) {
    var availableStartHour = timeSlotViewSettings.availableStartTime;
    var availableEndHour = timeSlotViewSettings.availableEndTime;

    // debugPrint("dateTime: $dateTime");
    if (availableStartHour == null || availableEndHour == null) {
      // debugPrint("availableStartHour: $availableStartHour");
      // debugPrint("availableEndHour: $availableEndHour");
      return true;
    } else if ((dateTime.isAtSameMomentAs(availableStartHour) ||
            dateTime.isAfter(availableStartHour)) &&
        dateTime.isBefore(availableEndHour)) {
      return true;
    } else {
      return false;
    }
  }
}

// /// Get the visible dates based on the date value and visible dates count.
// List getVisibleDates(dynamic date, int firstDayOfWeek, int visibleDatesCount) {
//   List datesCollection = <DateTime>[];

//   final dynamic currentDate =
//       getFirstDayOfWeekDate(visibleDatesCount, date, firstDayOfWeek);

//   for (int i = 0; i < visibleDatesCount; i++) {
//     final dynamic visibleDate = addDays(currentDate, i);
//     datesCollection.add(visibleDate);
//   }

//   return datesCollection;
// }

// /// Return date value without hour and minutes consideration.
// dynamic addDays(dynamic date, int days) {
//   return DateTime(date.year, date.month, date.day + days);
// }

// /// Calculate first day of week date value based original date with first day of
// /// week value.
// dynamic getFirstDayOfWeekDate(
//     int visibleDatesCount, dynamic date, int firstDayOfWeek) {
//   if (visibleDatesCount % 7 != 0) {
//     return date;
//   }

//   const int numberOfWeekDays = 7;
//   dynamic currentDate = date;
//   if (visibleDatesCount == 42) {
//     currentDate = DateTime(currentDate.year, currentDate.month);
//   }

//   // ignore: avoid_as
//   int value = -(currentDate.weekday as int) + firstDayOfWeek - numberOfWeekDays;
//   if (value.abs() >= numberOfWeekDays) {
//     value += numberOfWeekDays;
//   }

//   currentDate = addDays(currentDate, value);
//   return currentDate;
// }
