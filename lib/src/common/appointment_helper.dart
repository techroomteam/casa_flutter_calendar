import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/model/calendar_data_source.dart';
import 'package:casa_flutter_calendar/src/model/calendar_appointment.dart';
import 'package:flutter/material.dart';

import 'calendar_view_helper.dart';

class AppointmentHelper {
  static List<CalendarAppointment> appointmentsList = <CalendarAppointment>[];

  /// Generates the calendar appointments from the given data source
  static void initAppointmentList(
    dataSource,
  ) {
    AppointmentHelper.appointmentsList =
        AppointmentHelper.generateCalendarAppointments(dataSource);
  }

  static List<CalendarAppointment> generateCalendarAppointments(
      CalendarDataSource<Object?> calendarData) {
    final calendarAppointmentCollection = <CalendarAppointment>[];

    final List<dynamic> dataSource = calendarData.appointments;

    for (int i = 0; i < dataSource.length; i++) {
      final dynamic item = dataSource[i];
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
    );

    app.data = appointmentObject;

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
      startTime = appointment!.startTime;
      endTime = appointment.endTime;
    }

    int timeDifferenceInHours = endTime.hour - startTime.hour;

    return timeDifferenceInHours;
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
  static CalendarAppointment? getCalendarAppointmentOnPoint(
      double yPoint,
      CalendarAppointment dropedAppointment,
      List<CalendarAppointment> appointments) {
    // var x = offset.dx;
    // #1: Calculate dropped appointment top and bottom position
    var appointmentTop = yPoint - totalExtraHeight;
    int indexOfDroppedAppointment = appointments.indexOf(dropedAppointment);
    var appointmentDurationInInt = getAppoinmentDurationInInt(
        indexOfDroppedAppointment,
        appointment: dropedAppointment);
    var appointmentBottom = appointmentTop + (appointmentDurationInInt * 80);

    if (appointments.isEmpty) {
      return null;
    }

    CalendarAppointment? selectedAppointmentView;
    for (int i = 0; i < appointments.length; i++) {
      final CalendarAppointment appointmentView = appointments[i];
      // debugPrint("index: $i");
      // debugPrint("appointmentView.id: ${appointmentView.id}");
      // debugPrint("dropedAppointment.id: ${dropedAppointment.id}");
      // #2: If [appointmentView] is equal to [dropedAppointment] ignore it
      if (appointmentView.id != dropedAppointment.id) {
        // debugPrint("Index: $i");
        // debugPrint(
        //     "AppointmentOnPoint RRect: ${appointmentView.appointmentRect}");

        if ((appointmentTop >= appointmentView.appointmentRect.top &&
                appointmentTop <= appointmentView.appointmentRect.bottom) ||
            (appointmentBottom >= appointmentView.appointmentRect.top &&
                appointmentBottom <= appointmentView.appointmentRect.bottom)) {
          selectedAppointmentView = appointmentView;
          break;
        }
      }
    }

    return selectedAppointmentView;
  }

  ///
  static void onAcceptWithDetail(
    DragTargetDetails<CalendarAppointment> details,
    // double scrollOffset,
    void Function(Function() fn) setState,
  ) {
    debugPrint("onAcceptWithDetails: $details");
    double scrollOffset = scrollController.offset;
    double dropOffset =
        CalendarViewHelper.getAppointmentPositionAtTimeSlotFromOffset(
      details.offset,
      scrollOffset,
      totalExtraHeight,
    );
    debugPrint("Exect dropOffset: $dropOffset");

    int indexOfDroppedAppointment = appointmentsList.indexOf(details.data);

    if (indexOfDroppedAppointment == -1) {
      // value is not in list
      appointmentsList.add(details.data);
      setState(() {});
    } else {
      var appoinment = AppointmentHelper.getCalendarAppointmentOnPoint(
        details.offset.dy + scrollOffset,
        details.data,
        AppointmentHelper.appointmentsList,
      );

      // if appointment is null then we're good to update the appointment list
      // else we can't place appointment on another appointment
      if (appoinment == null) {
        updateCalendarAppointmentList(details.data, dropOffset);
        setState(() {});
      } else {
        debugPrint('Placing apointment on: ${appoinment.toString()}');
      }
    }
  }

  /// After [onAcceptWithDetails] if appointment is not placed on another then we need to update Calendar Appointment list
  static void updateCalendarAppointmentList(
      CalendarAppointment appointment, double dropOffset) {
    int index = AppointmentHelper.appointmentsList.indexOf(appointment);

    // get job duration from it's start date and end date
    final jobDurationInHour = AppointmentHelper.getAppoinmentDurationInInt(
        appointment: appointment, index);
    // debugPrint(
    //     "updateCalendarAppointmentList jobDurationInHour: $jobDurationInHour");
    double timeIntervalHeight = timeSlotViewSettings.timeIntervalHeight;
    double appRectBottom = dropOffset + timeIntervalHeight * jobDurationInHour;

    AppointmentHelper.appointmentsList[index].appointmentRect =
        RRect.fromLTRBAndCorners(0, dropOffset, 0, appRectBottom);
  }
}
