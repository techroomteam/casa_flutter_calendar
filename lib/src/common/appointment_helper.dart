import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/date_extension.dart';
import 'package:casa_flutter_calendar/src/model/calendar_data_source.dart';
import 'package:casa_flutter_calendar/src/model/calendar_appointment.dart';
import 'package:flutter/material.dart';

import 'calendar_view_helper.dart';

class AppointmentHelper {
  // static List<CalendarAppointment> appointmentsList = <CalendarAppointment>[];

  // /// Generates the calendar appointments from the given data source
  // static void initAppointmentList(
  //   dataSource,
  // ) {
  //   AppointmentHelper.appointmentsList =
  //       AppointmentHelper.generateCalendarAppointments(dataSource);
  // }

  static List<CalendarAppointment> generateCalendarAppointments(
      CalendarDataSource<Object?> calendarData) {
    final calendarAppointmentCollection = <CalendarAppointment>[];

    final List<dynamic> appointments = calendarData.appointments;

    for (int i = 0; i < appointments.length; i++) {
      final dynamic item = appointments[i];
      final CalendarAppointment app = createAppointment(item, calendarData);

      calendarAppointmentCollection.add(app);
    }

    return calendarAppointmentCollection;
  }

  /// This method covert  [CalendarDataSource] object to [CalendarAppointment]
  static CalendarAppointment createAppointment(
      appointmentObject, CalendarDataSource calendarData) {
    CalendarAppointment app;

    double intervalHeight = timeSlotViewSettings.timeIntervalHeight;

    final int index = calendarData.appointments.indexOf(appointmentObject);

    double heightFromTop =
        CalendarViewHelper.getAppointmentPositionAtTimeSlotFromStartTime(
            calendarData.getStartTime(index), intervalHeight);

    int timeDifferenceInHours =
        getAppoinmentDurationInInt(index, dataSource: calendarData);

    // heightFromTop = heightFromTop - totalExtraHeight;

    // We need to remove [TotalExtraHeight] from [heightFromTop] because [heightFromTop] is culculated base on [TimeSlotView]
    RRect appointmentRect = RRect.fromLTRBAndCorners(0, heightFromTop, 0,
        heightFromTop + intervalHeight * timeDifferenceInHours);

    debugPrint(" _createAppointment appointmentRect: $appointmentRect");

    app = CalendarAppointment(
      startTime: calendarData.getStartTime(index),
      endTime: calendarData.getEndTime(index),
      subject: calendarData.getSubject(index),
      color: calendarData.getColor(index),
      id: calendarData.getId(index),
      appointmentRect: appointmentRect,
      data: appointmentObject,
    );

    return app;
  }

  /// This method will get appointment duration from it's start and end time
  static int getAppoinmentDurationInInt(int index,
      {CalendarDataSource<Object?>? dataSource,
      CalendarAppointment? appointment}) {
    DateTime startTime;
    DateTime endTime;
    if (dataSource != null) {
      startTime = dataSource.getStartTime(index);
      endTime = dataSource.getEndTime(index);
    } else {
      startTime = appointment!.startTime!;
      endTime = appointment.endTime!;
    }

    int timeDifferenceInHours = endTime.hour - startTime.hour;

    return timeDifferenceInHours;
  }

  static int getAppoinmentDurationInHour(CalendarAppointment appointment) {
    DateTime? startTime = appointment.startTime;

    if (startTime == null) {
      return 2;
    } else {
      DateTime endTime = appointment.endTime!;
      int timeDifferenceInHours = endTime.hour - startTime.hour;
      return timeDifferenceInHours;
    }
  }

  ///
  static DateTime convertOffsetToDateTime(
    double offset,

    /// this field will is required, so full date can be returned with specific day
    DateTime dateTime,
  ) {
    final timeIntervalHeight = timeSlotViewSettings.timeIntervalHeight;
    final timeIntervalInMinutes = timeSlotViewSettings.timeInterval.inMinutes;
    debugPrint("timeIntervalInMinutes: $timeIntervalInMinutes");
    Duration duration = Duration(
      minutes: ((offset / timeIntervalHeight) * timeIntervalInMinutes).toInt(),
    );

    // 2: Convert droppedTime to DateTime
    var date = duration.toString().split(":");
    var hrs = int.parse(date[0]);
    var mns = int.parse(date[1]);
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hrs, mns);
  }

  ///
  static double getTotalExtraHeightFromTap(
      double headerHeight, double extraHeight) {
    double totalExtraHeight = headerHeight + extraHeight;
    return totalExtraHeight;
  }

  /// Need to pass [CalendarAppointment] (dropped) appointment
  ///
  /// This method will return appointment if user try to place it on another appointment otherwise it will return null
  static CalendarAppointment? getAllCalendarAppointmentOnPoint(
    double yPoint,
    CalendarAppointment dropedAppointment,
    List<CalendarAppointment> appointments,
    DateTime activeDate,
  ) {
    // #1: Calculate dropped appointment top and bottom position
    var appointmentTop = yPoint - totalExtraHeight;
    int indexOfDroppedAppointment = appointments.indexOf(dropedAppointment);
    var appointmentDurationInInt = getAppoinmentDurationInInt(
        indexOfDroppedAppointment,
        appointment: dropedAppointment);
    var appointmentBottom = appointmentTop +
        (appointmentDurationInInt * timeSlotViewSettings.timeIntervalHeight);

    if (appointments.isEmpty) {
      return null;
    }

    CalendarAppointment? selectedAppointmentView;
    for (int i = 0; i < appointments.length; i++) {
      // only compare record of active date, otherwise placement of job on Area of some other date will also not work
      final appointmentTime = appointments[i].startTime!;
      // remove hours, minutes or seconds from DateTime for easy comparision
      final appointmentTimeToDate = appointmentTime.dateToYMDTime();
      final activeDateToDate = activeDate.dateToYMDTime();

      if (appointmentTimeToDate.compareTo(activeDateToDate) == 0) {
        final CalendarAppointment appointmentView = appointments[i];

        // #2: If [appointmentView] is equal to [dropedAppointment] ignore it
        if (appointmentView.id != dropedAppointment.id &&
            appointmentView.appointmentRect != null) {
          if ((appointmentTop >= appointmentView.appointmentRect!.top &&
                  appointmentTop <= appointmentView.appointmentRect!.bottom) ||
              (appointmentBottom >= appointmentView.appointmentRect!.top &&
                  appointmentBottom <=
                      appointmentView.appointmentRect!.bottom)) {
            selectedAppointmentView = appointmentView;
            break;
          }
        }
      }
    }

    return selectedAppointmentView;
  }
}
