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
import 'package:casa_flutter_calendar/src/views/widgets/time_ruler_view.dart';
import 'package:flutter/material.dart';

import 'widgets/appointment_view.dart';
import 'widgets/time_slot_view.dart';
import 'widgets/unschedule_job_view.dart';

class CfCalendar extends StatefulWidget {
  final CalendarDataSource<Object?> dataSource;

  /// This appointment will be stacked into calendar view
  final CalendarAppointment? unScheduleAppointment;

  final DateTime activeDate;
  final TimeSlotViewSettings timeSlotViewSetting;
  final DaysHeaderViewSetting daysHeaderViewSetting;

  /// disable drag functionality
  final bool isDragAllowed;

  // /// appointmentObject is object from [dataSource.appointments]
  // final Widget Function(BuildContext, CalendarAppointment appointmentObject,
  //     CalendarAppointment selectedAppointment, Key? key)? appointmentBuilder;
  final void Function(DateTime)? onViewChanged;

  /// if user drag and drop the schedule appointment on available area then triggered the onJobScheduleChange function
  final void Function(String jobID, DateTime newScheduleTime)?
      onJobScheduleChange;
  final void Function(CalendarAppointment, DateTime) onAccept;

  const CfCalendar({
    required this.dataSource,
    this.unScheduleAppointment,
    // required this.selectedAppointment,
    required this.activeDate,
    // this.appointmentBuilder,
    this.timeSlotViewSetting = const TimeSlotViewSettings(),
    this.daysHeaderViewSetting = const DaysHeaderViewSetting(),
    this.isDragAllowed = true,
    this.onJobScheduleChange,
    this.onViewChanged,
    required this.onAccept,
    Key? key,
  }) : super(key: key);

  @override
  State<CfCalendar> createState() => _CfCalendarState();
}

class _CfCalendarState extends State<CfCalendar> {
  final _listViewKey = GlobalKey();
  // scroll controller
  final scrollController = ScrollController();

  /// This list hold list of widgets created with help of
  List<Widget> appointmentsWidgetList = [];
  bool _isDragging = false;

  //
  late double appointmentFeedbackWidth =
      MediaQuery.of(context).size.width / 1.16;

  //
  List<CalendarAppointment> appointmentsList = [];
  late CalendarAppointment? selectedAppointment = widget.unScheduleAppointment;
  CalendarAppointment? unScheduleAppointment;
  late DateTime activeDate = widget.activeDate;

  @override
  void initState() {
    // update [totalExtraHeight] value in constant file
    double headerHeight = widget.daysHeaderViewSetting.headerHeight;
    double extraHeight = widget.daysHeaderViewSetting.extraHeight;

    // debugPrint("headerHeight: $headerHeight");
    // debugPrint("extraHeight: $extraHeight");
    totalExtraHeight = headerHeight + extraHeight;
    // update [timeSlotViewSettings] in constant file
    timeSlotViewSettings = widget.timeSlotViewSetting;

    //
    initAppointmentList(widget.dataSource);

    //
    unScheduleAppointment = widget.unScheduleAppointment;

    // check availablility of unScheduleAppointment
    Future.delayed(const Duration(milliseconds: 400), () {
      debugPrint("InitState check Availablility");
      checkSelectedAppointmentAvailability(unScheduleAppointment);
      scrollToFirstAvailableOffset();
      setState(() {});
    });

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

  void scrollToFirstAvailableOffset() {
    debugPrint("appointmentsList length: ${appointmentsList.length}");
    // CalendarAppointment appointment = appointmentsList.firstWhere(
    //     (app) => app.startTime!.compareTo(activeDate) == 1,
    //     orElse: () => CalendarAppointment());

    // if (appointment.id != null) {
    //   debugPrint("appointmentID: ${appointment.id}");
    //   scrollController.jumpTo(appointment.appointmentRect!.top);
    // }

    /// if schedule new job screen then get availability of unschedule job

    if (selectedAppointment != null) {
      // debugPrint("appointmentID: ${appointment.id}");
      // scrollController.jumpTo(appointment.appointmentRect!.top);

      DateTime? availabilityStartTime;

      String selectedDay = activeDate.weekdayName()!;
      dynamic appointmentObject = selectedAppointment!.data;

      for (var availability in appointmentObject.availabilityList) {
        if (availability.days.contains(selectedDay)) {
          availabilityStartTime = DateTime(activeDate.year, activeDate.month,
              activeDate.day, availability.fromTime.hour);
          break;
        }
      }

      if (availabilityStartTime != null) {
        double topOffset =
            CalendarViewHelper.getAppointmentPositionAtTimeSlotFromStartTime(
                availabilityStartTime, timeSlotViewSettings.timeIntervalHeight);

        scrollController.jumpTo(topOffset);
      } else {
        scrollController.jumpTo(0);
      }
    }
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
              children: [
                CalendarDaysListView(
                  daysHeaderViewSetting: widget.daysHeaderViewSetting,
                  onNewSelection: (newDate) {
                    // #1: Update activeDate value
                    activeDate = newDate;
                    // #2: if unschedule appointment has been placed on previous date, then move it back to bottom stacked position
                    if (unScheduleAppointment == null &&
                        widget.unScheduleAppointment != null) {
                      int index = appointmentsList.indexWhere((element) =>
                          element.id == widget.unScheduleAppointment!.id);

                      appointmentsList.removeAt(index);
                      unScheduleAppointment = widget.unScheduleAppointment;
                    }

                    // if selected appointment is other then unschedule appointment then restore the initial
                    selectedAppointment = widget.unScheduleAppointment;

                    // recheck the availablility
                    checkSelectedAppointmentAvailability(selectedAppointment);

                    // scroll to first available slot offset
                    scrollToFirstAvailableOffset();
                  },
                  appointmentsList: appointmentsList,
                  activeDate: activeDate,
                ),

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

          //selected job
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: widget.unScheduleAppointment == null
                ? const SizedBox.shrink()
                : unScheduleAppointment == null
                    ? GestureDetector(
                        onTap: () {
                          final calendarApp = appointmentsList.last;
                          DateTime scheduleJobTime = DateTime(
                            activeDate.year,
                            activeDate.month,
                            activeDate.day,
                            calendarApp.startTime!.hour,
                            calendarApp.startTime!.minute,
                          );
                          widget.onAccept(
                              appointmentsList.last, scheduleJobTime);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                // changes position of shadow
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const CasaButton(text: 'Accept'),
                        ),
                      )
                    : Draggable<CalendarAppointment>(
                        data: unScheduleAppointment,
                        onDragStarted: () {
                          // #1: Change [selectedAppointment] data
                          selectedAppointment = widget.unScheduleAppointment;
                          // #2: Change availablity slots
                          checkSelectedAppointmentAvailability(
                              selectedAppointment);
                          setState(() {});
                        },
                        feedback:
                            feedbackAppointmentBuilder(unScheduleAppointment),
                        childWhenDragging: const SizedBox.shrink(),
                        child: UnScheduleJobView(
                          unscheduleAppointmentObject: unScheduleAppointment,
                          selectedAppointment: selectedAppointment!,
                          appointmentBuilder: (_, app, __, ___) =>
                              appointmentBuilder(app, customHeight: 80),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget feedbackAppointmentBuilder(CalendarAppointment? appointment) {
    if (appointment == null) {
      return const SizedBox.shrink();
    }

    dynamic appointmentData = appointment.data;
    int numberOfHours = appointmentData.jobDurationInHours;
    double appointmentHeight =
        AppointmentHelper.appointmentHeightFromNumberOfHour(numberOfHours);

    return Material(
      child: SizedBox(
        width: appointmentFeedbackWidth,
        height: appointmentHeight,
        child: appointmentBuilder(appointment),
      ),
    );
  }

  Widget appointmentBuilder(CalendarAppointment appointment,
      {double? customHeight}) {
    bool isSelectedJob = false;
    if (selectedAppointment != null) {
      isSelectedJob = selectedAppointment!.id == appointment.id;
    }

    final numberOfHours =
        AppointmentHelper.getAppoinmentDurationFromCalendarAppointment(
            appointment);

    double appointmentHeight =
        AppointmentHelper.appointmentHeightFromNumberOfHour(numberOfHours);

    return AppointmentView(
      height: customHeight ?? appointmentHeight,
      jobInfo: appointment.data,
      color: isSelectedJob ? selectedAppointmentColor : appBackgroundColor,
      textColor: isSelectedJob ? Colors.white : blackAccent1,
      onTap: () {
        // #1: Change [selectedAppointment] data
        selectedAppointment = appointment;
        // #2: Change availablity slots
        checkSelectedAppointmentAvailability(appointment);
      },
    );
  }

  /// this method will convert [CasaAppointment] list to widgetsList
  /// We also need to check if appointment is on the active date, becasue we only need to show active date appointments on active view
  List<Widget> getListOfAppointmentWidgets() {
    // debugPrint("getListOfAppointmentWidgets");
    List<Widget> childrens = [];

    for (int i = 0; i < appointmentsList.length; i++) {
      final appointment = appointmentsList[i];

      /// startTime or endTime values could be null after draging unsceduled appointment on the DragTarget
      /// we should assigned those values according to dragged position

      final appointmentTime = appointment.startTime!;
      // remove hours, minutes or seconds from DateTime for easy comparision
      final appointmentTimeToDate = appointmentTime.dateToYMDTime();
      final activeDateToDate = activeDate.dateToYMDTime();

      if (appointmentTimeToDate.compareTo(activeDateToDate) == 0) {
        childrens.add(
          Positioned(
              top: appointment.appointmentRect!.top,
              left: 0,
              right: 0,
              child: LongPressDraggable<CalendarAppointment>(
                axis: Axis.vertical,
                data: appointment,
                maxSimultaneousDrags: widget.isDragAllowed ? 1 : 0,
                onDragStarted: () {
                  _isDragging = true;
                  selectedAppointment = appointment;
                  checkSelectedAppointmentAvailability(appointment);
                  debugPrint("onDragStarted");
                },
                onDragEnd: (details) => _isDragging = false,
                onDraggableCanceled: (velocity, offset) => _isDragging = false,
                // feedback: Material(
                //   child: SizedBox(
                //     width: appointmentFeedbackWidth,
                //     child: appointmentBuilder(appointment),
                //   ),
                // ),
                feedback: feedbackAppointmentBuilder(appointment),
                childWhenDragging: const SizedBox.shrink(),
                child: appointmentBuilder(appointment),
              )),
        );
      }
    }

    return childrens;
  }

  /// This method will get renter availablity of particular day from Ticket Availablity object
  void checkSelectedAppointmentAvailability(CalendarAppointment? appointment) {
    debugPrint("checkSelectedAppointmentAvailability");
    debugPrint("appointmentid: ${appointment?.id}");
    String selectedDay = activeDate.weekdayName()!;
    if (appointment != null) {
      dynamic appointmentObject = appointment.data;
      bool isAvailable = false;

      debugPrint("selectedDay: $selectedDay");
      debugPrint("availabilityList: ${appointmentObject.availabilityList}");

      for (var availability in appointmentObject.availabilityList) {
        if (availability.days.contains(selectedDay)) {
          // Update the dates in timeSlotViewSettings
          timeSlotViewSettings = timeSlotViewSettings.copyWith(
            availableStartTime: availability.fromTime,
            availableEndTime: availability.toTime,
          );

          isAvailable = true;
          break;
        }
      }

      debugPrint("isAvailable: $isAvailable");

      if (!isAvailable) {
        timeSlotViewSettings = timeSlotViewSettings.copyWith(
          availableStartTime: null,
          availableEndTime: null,
        );
      }
    }

    setState(() {});
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
            details.offset, scrollOffset, totalExtraHeight);
    debugPrint("Exact dropOffset: $dropOffset");

    int indexOfDroppedAppointment = appointmentsList.indexOf(details.data);
    debugPrint("indexOfDroppedAppointment: $indexOfDroppedAppointment");

    //#1: First check if dropped appoinment is unscheduled
    if (indexOfDroppedAppointment == -1) {
      var droppedAppointment = details.data;
      // First add droppedAppointment to the list because it's needed in _updateCalendarAppointmentList
      appointmentsList.add(droppedAppointment);

      _updateCalendarAppointmentList(droppedAppointment, dropOffset,
          isUnscheduleAppointment: true);
    } else {
      var appoinment = AppointmentHelper.getAllCalendarAppointmentOnPoint(
        details.offset.dy + scrollOffset,
        details.data,
        appointmentsList,
        activeDate,
      );

      // if appointment is null then we're good to update the appointment list
      // else we can't place appointment on another appointment
      if (appoinment == null) {
        _updateCalendarAppointmentList(details.data, dropOffset);
      } else {
        debugPrint('Placing apointment on: ${appoinment.toString()}');
      }
    }
  }

  /// After [onAcceptWithDetails] if appointment is not placed on another then we need to update Calendar Appointment list
  void _updateCalendarAppointmentList(
    CalendarAppointment appointment,
    double dropOffset, {

    /// if this is true that means the dropped appointment is not already in appointmentsList
    bool isUnscheduleAppointment = false,
  }) {
    int index = appointmentsList.indexOf(appointment);
    // debugPrint("DroppedIndex: $index");

    dynamic appointmentData = appointment.data;
    int appointmentDuration = appointmentData.jobDurationInHours;

    // #1: Update datetime value according to new positioned value
    DateTime droppedStartTime =
        AppointmentHelper.convertOffsetToDateTime(dropOffset, activeDate);
    debugPrint("droppedStartTime: $droppedStartTime");
    DateTime droppedEndTime =
        droppedStartTime.add(Duration(hours: appointmentDuration));
    debugPrint("droppedEndTime: $droppedEndTime");

    // #2: Make sure dropped time is not in unavailable area
    // Check both start and end time

    bool isAreaAvailable =
        CalendarViewHelper.isAppointmentDroppedOnAvailableArea(
            droppedStartTime, droppedEndTime);

    // debugPrint("isAreaAvailable: $isAreaAvailable");

    if (isAreaAvailable) {
      appointmentsList[index] = appointmentsList[index]
          .copyWith(startTime: droppedStartTime, endTime: droppedEndTime);

      // #3: Update appointment RRect value
      double timeIntervalHeight = timeSlotViewSettings.timeIntervalHeight;

      int slotCount = AppointmentHelper.calculateAppointmentSlotCountFromHour(
          appointmentDuration);

      double heightFromTop =
          CalendarViewHelper.getAppointmentPositionAtTimeSlotFromStartTime(
              droppedStartTime, timeIntervalHeight);

      debugPrint("heightFromTop: $heightFromTop");

      double appRectBottom = heightFromTop + timeIntervalHeight * slotCount;

      final rRect =
          RRect.fromLTRBAndCorners(0, heightFromTop, 0, appRectBottom);

      appointmentsList[index].appointmentRect = rRect;

      /// if appointment is unSchedule and it's dropped on right timeSlot
      if (isUnscheduleAppointment) {
        unScheduleAppointment = null;
      } else {
        /// Trigger 'onJobScheduleChange' function if 'isAreaAvailable'
        if (widget.onJobScheduleChange != null) {
          debugPrint("widget.onJobScheduleChange");
          widget.onJobScheduleChange!(appointmentData.id, droppedStartTime);
        }
      }
    } else {
      /// If [isUnscheduleAppointment] then remove it from list in case slot is not available
      if (isUnscheduleAppointment) {
        appointmentsList.removeAt(index);
        unScheduleAppointment = appointment;
      } else {
        // if not [isUnscheduleAppointment] then restore the old state
        appointmentsList[index] = appointment;
      }
    }

    setState(() {});
  }
}
