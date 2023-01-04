import 'package:casa_flutter_calendar/src/common/appointment_helper.dart';
import 'package:casa_flutter_calendar/src/common/calendar_view_helper.dart';
import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/date_extension.dart';
import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:casa_flutter_calendar/src/model/calendar_data_source.dart';
import 'package:casa_flutter_calendar/src/model/calendar_appointment.dart';
import 'package:casa_flutter_calendar/src/settings/days_header_view_setting.dart';
import 'package:casa_flutter_calendar/src/settings/time_slot_view_setting.dart';
import 'package:casa_flutter_calendar/src/views/week_day_view.dart';
import 'package:casa_flutter_calendar/src/views/widgets/casa_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'widgets/appointment_view.dart';

class CfCalendar extends StatefulWidget {
  final CalendarDataSource<Object?> dataSource;

  /// This appointment will be stacked into calendar view
  final CalendarAppointment unScheduleAppointment;
  // final CalendarAppointment selectedAppointment;

  final DateTime activeDate;

  /// appointmentObject is object from [dataSource.appointments]
  final Widget Function(BuildContext, CalendarAppointment appointmentObject,
      CalendarAppointment selectedAppointment, Key? key)? appointmentBuilder;
  final void Function(DateTime)? onViewChanged;
  final TimeSlotViewSettings timeSlotViewSetting;
  final DaysHeaderViewSetting daysHeaderViewSetting;
  const CfCalendar({
    required this.dataSource,
    required this.unScheduleAppointment,
    // required this.selectedAppointment,
    required this.activeDate,
    this.appointmentBuilder,
    this.timeSlotViewSetting = const TimeSlotViewSettings(),
    this.daysHeaderViewSetting = const DaysHeaderViewSetting(),
    this.onViewChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<CfCalendar> createState() => _CfCalendarState();
}

class _CfCalendarState extends State<CfCalendar> {
  // final GlobalKey _draggableKey = GlobalKey();
  final _listViewKey = GlobalKey();
  // scroll controller
  final scrollController = ScrollController();

  /// This list hold list of widgets created with help of
  List<Widget> appointmentsWidgetList = [];
  bool _isDragging = false;

  //
  List<CalendarAppointment> appointmentsList = [];
  late CalendarAppointment selectedAppointment = widget.unScheduleAppointment;
  CalendarAppointment? unScheduleAppointment;

  @override
  void initState() {
    // update [totalExtraHeight] value in constant file
    double headerHeight = widget.daysHeaderViewSetting.headerHeight;
    double extraHeight = widget.daysHeaderViewSetting.extraHeight;

    debugPrint("headerHeight: $headerHeight");
    debugPrint("extraHeight: $extraHeight");
    totalExtraHeight = headerHeight + extraHeight;
    // update [timeSlotViewSettings] in constant file
    timeSlotViewSettings = widget.timeSlotViewSetting;
    //
    initAppointmentList(widget.dataSource);

    //
    unScheduleAppointment = widget.unScheduleAppointment;

    super.initState();
  }

  void initAppointmentList(dataSource) {
    appointmentsList =
        AppointmentHelper.generateCalendarAppointments(dataSource);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appointmentsWidgetList = getListOfAppointmentWidgets();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              // physics: const NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              children: [
                CalendarDaysListView(
                  daysHeaderViewSetting: widget.daysHeaderViewSetting,
                  onNewSelection: widget.onViewChanged,
                  activeDate: widget.activeDate,
                ),

                // const SizedBox(height: 24),
                // TimeSlot and TimeRuler View
                Expanded(
                  child: _createListener(
                    Scrollbar(
                      controller: scrollController,
                      child: ListView(
                        shrinkWrap: true,
                        key: _listViewKey,
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        // physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: TimeRulerView()),
                              Expanded(
                                flex: 6,
                                child: Stack(
                                  children: [
                                    DragTarget<CalendarAppointment>(
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        return TimeSlotView(
                                          timeSlotViewSetting:
                                              widget.timeSlotViewSetting,
                                        );
                                      },
                                      onAcceptWithDetails: (details) =>
                                          onAcceptWithDetail(
                                              details, scrollController.offset),
                                    ),
                                    for (int i = 0;
                                        i < appointmentsWidgetList.length;
                                        i++)
                                      appointmentsWidgetList[i]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //
          //selected job
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: unScheduleAppointment == null
                ? Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const CasaButton(text: 'Accept'),
                  )
                : LongPressDraggable<CalendarAppointment>(
                    data: widget.unScheduleAppointment,
                    feedback: Material(
                        child: appointmentBuilder(unScheduleAppointment!)),
                    childWhenDragging: const SizedBox.shrink(),
                    child: UnScheduleJobView(
                      unscheduleAppointmentObject: unScheduleAppointment,
                      selectedAppointment: selectedAppointment,
                      // appointmentBuilder: widget.appointmentBuilder!,
                      appointmentBuilder: (_, app, __, ___) =>
                          appointmentBuilder(app),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget appointmentBuilder(CalendarAppointment appointment) {
    bool isSelectedJob = selectedAppointment.id == appointment.id;
    final numberOfHours =
        AppointmentHelper.getAppoinmentDurationInHour(appointment);
    // debugPrint("appointmentBuilder");
    return GestureDetector(
      onTap: () {
        // #1: Change [selectedAppointment] data
        selectedAppointment = appointment;
        // #2: Change availablity slots
        checkAvailability(appointment.data);
        // debugPrint("On appointment Tap");
        setState(() {});
      },
      child: AppointmentView(
        height: appointment.id == widget.unScheduleAppointment.id
            ? 80
            : timeSlotViewSettings.timeIntervalHeight * numberOfHours,
        jobInfo: appointment.data,
        color: isSelectedJob ? selectedAppointmentColor : appBackgroundColor,
        textColor: isSelectedJob ? Colors.white : blackAccent1,
      ),
    );
    //     widget.appointmentBuilder!(
    //   context,
    //   appointment,
    //   selectedAppointment,
    //   // AppointmentHelper.appointmentsList[i],
    //   null,
    // );
  }

  /// this method will covert [CasaAppointment] list to widgetsList
  /// We also need to check if appointment is on the active date, becasue we only need to show active date appointments on active view
  List<Widget> getListOfAppointmentWidgets() {
    debugPrint("getListOfAppointmentWidgets");
    List<Widget> childrens = [];

    for (int i = 0; i < appointmentsList.length; i++) {
      final appointment = appointmentsList[i];

      /// startTime or endTime values could be null after draging unsceduled appointment on the DragTarget
      /// we should assigned those values according to dragged position
      final appointmentTime = appointment.startTime!;
      // remove hours, minutes or seconds from DateTime for easy comparision
      final appTimeToDate = DateTime(
          appointmentTime.year, appointmentTime.month, appointmentTime.day);
      final activeDateToDate = DateTime(widget.activeDate.year,
          widget.activeDate.month, widget.activeDate.day);

      if (appTimeToDate.compareTo(activeDateToDate) == 0) {
        childrens.add(
          Positioned(
            top: appointment.appointmentRect!.top,
            left: 0,
            right: 0,
            child: widget.appointmentBuilder != null
                ? LongPressDraggable<CalendarAppointment>(
                    axis: Axis.vertical,
                    data: appointment,
                    onDragStarted: () => _isDragging = true,
                    onDragEnd: (details) => _isDragging = false,
                    onDraggableCanceled: (velocity, offset) =>
                        _isDragging = false,
                    feedback: Material(child: appointmentBuilder(appointment)),
                    childWhenDragging: const SizedBox.shrink(),
                    child: appointmentBuilder(appointment),
                  )
                : defaultAppointmentView(),
          ),
        );
      }
    }

    return childrens;
  }

  /// This method will get renter availablity of particular day from Ticket Availablity object
  void checkAvailability(dynamic appointment) {
    String selectedDay = widget.activeDate.weekdayName()!;
    debugPrint('selectedDay: $selectedDay');

    dynamic appointmentObject = appointment;

    bool isAvailable = false;

    for (var availability in appointmentObject.availabilityList) {
      if (availability.days.contains(selectedDay)) {
        debugPrint("availability: ${availability.days}");
        debugPrint("availability from: ${availability.fromTime}");
        var availableStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          availability.fromTime!.hour,
          availability.fromTime!.minute,
        );
        var availableEndTime = DateTime(
          now.year,
          now.month,
          now.day,
          availability.toTime!.hour,
          availability.toTime!.minute,
        );

        // debugPrint("availableStartTime: $availableStartTime");
        // debugPrint("availableEndTime: $availableEndTime");

        // Update the dates in timeSlotViewSettings

        timeSlotViewSettings = timeSlotViewSettings.copyWith(
          availableStartTime: availableStartTime,
          availableEndTime: availableEndTime,
        );

        isAvailable = true;
        break;
      }
    }

    if (!isAvailable) {
      debugPrint("isAvailable: $isAvailable");
      timeSlotViewSettings = timeSlotViewSettings.copyWith(
        availableStartTime: null,
        availableEndTime: null,
      );
    }
  }

  Widget defaultAppointmentView() {
    return Container(
      color: Colors.yellow,
      height: widget.timeSlotViewSetting.timeIntervalHeight,
    );
  }

  Widget _createListener(Widget child) {
    return Listener(
      child: child,
      onPointerMove: (PointerMoveEvent event) {
        if (!_isDragging) {
          return;
        }
        RenderBox render =
            _listViewKey.currentContext?.findRenderObject() as RenderBox;
        Offset position = render.localToGlobal(Offset.zero);
        double topY = position.dy;
        double bottomY = topY + render.size.height;

        const detectedRange = 100;
        const moveDistance = 10;

        if (event.position.dy < topY + detectedRange) {
          var to = scrollController.offset - moveDistance;
          to = (to < 0) ? 0 : to;
          scrollController.jumpTo(to);
        }
        if (event.position.dy > bottomY - detectedRange) {
          scrollController.jumpTo(scrollController.offset + moveDistance);
        }
      },
    );
  }

  ///
  void onAcceptWithDetail(
      DragTargetDetails<CalendarAppointment> details, double scrollOffset) {
    debugPrint("onAcceptWithDetails: $details");

    double dropOffset =
        CalendarViewHelper.getAppointmentPositionAtTimeSlotFromOffset(
      details.offset,
      scrollOffset,
      totalExtraHeight,
    );
    debugPrint("Exact dropOffset: $dropOffset");

    int indexOfDroppedAppointment = appointmentsList.indexOf(details.data);

    if (indexOfDroppedAppointment == -1) {
      //#1: First check if dropped appoinment is unscheduled
      var droppedAppointment = details.data;

      //
      if (droppedAppointment.startTime == null) {
        final height =
            totalExtraHeight + timeSlotViewSettings.timeIntervalHeight;
        debugPrint("totalExtraHeight: $totalExtraHeight");
        debugPrint("Height: $height");
        // If this condition is true that means droppedAppointment is unscheduled
        double droppedTime = (dropOffset + scrollOffset) /
            timeSlotViewSettings.timeIntervalHeight;

        //#TODO: 2: Convert droppedTime to DateTime

        debugPrint("DroppedTime: $droppedTime");
      }

      var activeDate = widget.activeDate;

      //#TODO: Update Hours value
      droppedAppointment = droppedAppointment.copyWith(
        startTime:
            DateTime(activeDate.year, activeDate.month, activeDate.day, 1),
        endTime: DateTime(activeDate.year, activeDate.month, activeDate.day, 3),
      );
      // value is not in list
      appointmentsList.add(droppedAppointment);

      unScheduleAppointment = null;

      _updateCalendarAppointmentList(droppedAppointment, dropOffset);
      setState(() {});
    } else {
      var appoinment = AppointmentHelper.getCalendarAppointmentOnPoint(
        details.offset.dy + scrollOffset,
        details.data,
        appointmentsList,
      );

      // if appointment is null then we're good to update the appointment list
      // else we can't place appointment on another appointment
      if (appoinment == null) {
        _updateCalendarAppointmentList(details.data, dropOffset);
        setState(() {});
      } else {
        debugPrint('Placing apointment on: ${appoinment.toString()}');
      }
    }
  }

  /// After [onAcceptWithDetails] if appointment is not placed on another then we need to update Calendar Appointment list
  void _updateCalendarAppointmentList(
      CalendarAppointment appointment, double dropOffset) {
    int index = appointmentsList.indexOf(appointment);

    // get job duration from it's start date and end date
    final jobDurationInHour = AppointmentHelper.getAppoinmentDurationInInt(
        index,
        appointment: appointment);
    // debugPrint(
    //     "updateCalendarAppointmentList jobDurationInHour: $jobDurationInHour");
    double timeIntervalHeight = timeSlotViewSettings.timeIntervalHeight;
    double appRectBottom = dropOffset + timeIntervalHeight * jobDurationInHour;

    appointmentsList[index].appointmentRect =
        RRect.fromLTRBAndCorners(0, dropOffset, 0, appRectBottom);
  }
}

class TimeRulerView extends StatelessWidget {
  const TimeRulerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSettings);
    final timeSlotCount =
        CalendarViewHelper.getTimeSlotCount(timeSlotViewSettings);

    final timeTextStyle =
        timeSlotViewSettings.timeTextStyle ?? CfCalendarStyle.timeTextStyle;

    final double hour = (timeSlotViewSettings.startHour -
            timeSlotViewSettings.startHour.toInt()) *
        60;

    var currentDate = now;

    List<Widget> children = [];

    for (int i = 0; i < timeSlotCount; i++) {
      final double minute = (i * timeInterval) + hour;
      currentDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        timeSlotViewSettings.startHour.toInt(),
        minute.toInt(),
      );

      // Check if currentDate is in AvailableTime or not
      bool isInAvailableArea =
          CalendarViewHelper.isTimeSlotInAvailableArea(currentDate);

      final String time =
          DateFormat(timeSlotViewSettings.timeFormat).format(currentDate);
      final Text textWidget = Text(
        time,
        style: timeTextStyle.copyWith(
          color: isInAvailableArea ? timeTextColor : unAvailableTimeTextColor,
        ),
      );
      children.add(SizedBox(
        height: timeSlotViewSettings.timeIntervalHeight,
        child: textWidget,
      ));
    }

    return Column(children: children);
  }
}

class TimeSlotView extends StatelessWidget {
  final TimeSlotViewSettings timeSlotViewSetting;
  const TimeSlotView({
    this.timeSlotViewSetting = const TimeSlotViewSettings(),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeSlotCount =
        CalendarViewHelper.getTimeSlotCount(timeSlotViewSetting);

    List<Widget> children = [];

    for (int i = 0; i < timeSlotCount; i++) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: timeSlotViewSetting.timeIntervalHeight),
          child: const Divider(
            height: 0,
            color: timeSlotLineColor,
            thickness: 1,
          ),
        ),
      );
    }

    return Column(children: children);
  }
}

//
class UnScheduleJobView extends StatelessWidget {
  final CalendarAppointment? unscheduleAppointmentObject;
  final CalendarAppointment selectedAppointment;
  final Widget Function(
          BuildContext, CalendarAppointment, CalendarAppointment, Key?)
      appointmentBuilder;
  const UnScheduleJobView({
    required this.unscheduleAppointmentObject,
    required this.appointmentBuilder,
    required this.selectedAppointment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('To Accept job drag it to desired time first '),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GridView
              SizedBox(
                width: 16,
                height: 50,
                child: GridView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5.6,
                    crossAxisSpacing: 4.2,
                  ),
                  itemBuilder: (context, index) => Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // appointment view
              appointmentBuilder(context, unscheduleAppointmentObject!,
                  selectedAppointment, null),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
