import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/date_extension.dart';
import 'package:casa_flutter_calendar/src/settings/time_slot_view_setting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    int timeInMinutes = startTime.hour * 60 + startTime.minute;
    int timeIntervalInInt = timeSlotViewSettings.timeInterval.inMinutes;
    debugPrint("timeIntervalInInt: $timeIntervalInInt");
    debugPrint("startTime.hour: ${startTime.hour}");
    int totalSlotCount = timeInMinutes ~/ timeIntervalInInt;
    debugPrint("totalSlotCount: $totalSlotCount");
    return totalSlotCount * timeIntervalHeight;
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

  /// This method will return true if dateTime is in available area
  static bool isTimeSlotInAvailableArea(DateTime dateTime) {
    var availableStartTime = timeSlotViewSettings.availableStartTime;
    var availableEndTime = timeSlotViewSettings.availableEndTime;

    // debugPrint(
    //     "availableStartTime: ${timeSlotViewSettings.availableStartTime}");
    // debugPrint("availableEndTime: ${timeSlotViewSettings.availableEndTime}");

    if (availableStartTime == null || availableEndTime == null) {
      return false;
    } else {
      DateTime startTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          availableStartTime.hour, availableStartTime.minute);
      DateTime endTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          availableEndTime.hour, availableEndTime.minute);
      if ((dateTime.isAtSameMomentAs(startTime) ||
              dateTime.isAfter(startTime)) &&
          dateTime.isBefore(endTime)) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// This method will compare dropped appoinment start and end time with availablity time, if availabe then allow placing
  static bool isAppointmentDroppedOnAvailableArea(
      DateTime startTime, DateTime endTime) {
    bool isStartTimeAvailable = isTimeSlotInAvailableArea(startTime);
    bool isEndTimeAvailable = isTimeSlotInAvailableArea(endTime);

    // debugPrint("startTime: $startTime");
    // debugPrint("endTime: $endTime");
    // debugPrint("isStartTimeAvailable: $isStartTimeAvailable");
    // debugPrint("isEndTimeAvailable: $isEndTimeAvailable");

    if (isStartTimeAvailable && isEndTimeAvailable) {
      return true;
    } else {
      return false;
    }
  }

  static String getAvailabilityTimeOfDay(
      dynamic availabilityList, DateTime dateTime) {
    String selectedDay = dateTime.weekdayName()!;
    // debugPrint("selectedDay: " + selectedDay);
    // debugPrint("availabilityList: $availabilityList");
    // debugPrint("dateTime: $dateTime");

    for (var availability in availabilityList) {
      // debugPrint("availability: $availability");
      if (availability.days.contains(selectedDay)) {
        TimeOfDay startTime = availability.fromTime;
        TimeOfDay toTime = availability.toTime;
        DateTime startDate = DateTime(dateTime.year, dateTime.month,
            dateTime.day, startTime.hour, startTime.minute);
        DateTime endDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            toTime.hour, toTime.minute);
        String startTimeFormat = DateFormat("hh:mm a").format(startDate);
        String endTimeFormat = DateFormat("hh:mm a").format(endDate);
        // debugPrint("TimeOfJob: " + '$startTimeFormat - $endTimeFormat');
        return '$startTimeFormat - $endTimeFormat';
      }
    }

    // debugPrint("TimeOfJob: ");

    return '';
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
