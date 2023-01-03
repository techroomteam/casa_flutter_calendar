import 'package:casa_flutter_calendar/src/common/appointment_helper.dart';
import 'package:casa_flutter_calendar/src/common/calendar_view_helper.dart';
import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:casa_flutter_calendar/src/model/calendar_data_source.dart';
import 'package:casa_flutter_calendar/src/model/calendar_appointment.dart';
import 'package:casa_flutter_calendar/src/settings/days_header_view_setting.dart';
import 'package:casa_flutter_calendar/src/settings/time_slot_view_setting.dart';
import 'package:casa_flutter_calendar/src/views/week_day_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class CfCalendar extends StatefulWidget {
  final CalendarDataSource<Object?> dataSource;

  final DateTime activeDate;

  /// appointmentObject is object from [dataSource.appointments]
  final Widget Function(BuildContext, dynamic appointmentObject, Key? key)?
      appointmentBuilder;
  final void Function(DateTime)? onViewChanged;
  final TimeSlotViewSettings timeSlotViewSetting;
  final DaysHeaderViewSetting daysHeaderViewSetting;
  const CfCalendar({
    required this.dataSource,
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
  List<Widget> appointmentsWidgetList = [];
  bool _isDragging = false;

  @override
  void initState() {
    // update [totalExtraHeight] value in constant file
    double headerHeight = widget.daysHeaderViewSetting.headerHeight;
    double extraHeight = widget.daysHeaderViewSetting.extraHeight;
    totalExtraHeight = headerHeight + extraHeight;
    // update [timeSlotViewSettings] in constant file
    timeSlotViewSettings = widget.timeSlotViewSetting;
    //
    AppointmentHelper.initAppointmentList(widget.dataSource);

    super.initState();
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
      body: SizedBox(
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
                          Expanded(
                            flex: 1,
                            child: TimeRulerView(
                              timeSlotViewSetting: widget.timeSlotViewSetting,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Stack(
                              children: [
                                DragTarget<CalendarAppointment>(
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return TimeSlotView(
                                      timeSlotViewSetting:
                                          widget.timeSlotViewSetting,
                                    );
                                  },
                                  onAcceptWithDetails: (details) =>
                                      AppointmentHelper.onAcceptWithDetail(
                                    details,
                                    // scrollController.offset,
                                    setState,
                                  ),
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
    );
  }

  /// this method will covert [CasaAppointment] list to widgetsList
  /// We also need to check if appointment is on the active date, becasue we only need to show active date appointments on active view
  List<Widget> getListOfAppointmentWidgets() {
    List<Widget> childrens = [];

    for (int i = 0; i < AppointmentHelper.appointmentsList.length; i++) {
      final appointment = AppointmentHelper.appointmentsList[i];

      final appointmentTime = appointment.startTime;
      // remove hours, minutes or seconds from DateTime for easy comparision
      final appTimeToDate = DateTime(
          appointmentTime.year, appointmentTime.month, appointmentTime.day);
      final activeDateToDate = DateTime(widget.activeDate.year,
          widget.activeDate.month, widget.activeDate.day);

      if (appTimeToDate.compareTo(activeDateToDate) == 0) {
        childrens.add(
          Positioned(
            top: appointment.appointmentRect.top,
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
                    feedback: Material(
                      child: widget.appointmentBuilder!(
                        context,
                        widget.dataSource.appointments[i],
                        // AppointmentHelper.appointmentsList[i],
                        null,
                      ),
                    ),
                    childWhenDragging: const SizedBox.shrink(),
                    child: widget.appointmentBuilder!(
                      context,
                      widget.dataSource.appointments[i],
                      // AppointmentHelper.appointmentsList[i],
                      null,
                    ),
                  )
                : defaultAppointmentView(),
          ),
        );
      }
    }

    return childrens;
  }

  // /// After [onAcceptWithDetails] if appointment is not placed on another then we need to update Calendar Appointment list
  // void updateCalendarAppointmentList(
  //     CalendarAppointment appointment, double dropOffset) {
  //   double timeIntervalHeight = widget.timeSlotViewSetting.timeIntervalHeight;
  //   AppointmentHelper.updateCalendarAppointmentList(appointment, dropOffset);
  //   setState(() {});
  // }

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
}

class TimeRulerView extends StatelessWidget {
  final TimeSlotViewSettings timeSlotViewSetting;
  const TimeRulerView({
    this.timeSlotViewSetting = const TimeSlotViewSettings(),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int timeInterval =
        CalendarViewHelper.getTimeInterval(timeSlotViewSetting);
    final timeSlotCount =
        CalendarViewHelper.getTimeSlotCount(timeSlotViewSetting);

    final timeTextStyle =
        timeSlotViewSetting.timeTextStyle ?? CfCalendarStyle.timeTextStyle;

    final double hour = (timeSlotViewSetting.startHour -
            timeSlotViewSetting.startHour.toInt()) *
        60;

    var currentDate = DateTime.now();

    List<Widget> children = [];

    for (int i = 0; i < timeSlotCount; i++) {
      final double minute = (i * timeInterval) + hour;
      currentDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        timeSlotViewSetting.startHour.toInt(),
        minute.toInt(),
      );

      // Check if currentDate is in AvailableTime or not
      bool isInAvailableArea =
          CalendarViewHelper.isTimeSlotInAvailableArea(currentDate);

      final String time =
          DateFormat(timeSlotViewSetting.timeFormat).format(currentDate);
      final Text textWidget = Text(
        time,
        style: timeTextStyle.copyWith(
          color: isInAvailableArea ? timeTextColor : unAvailableTimeTextColor,
        ),
      );
      children.add(SizedBox(
        height: timeSlotViewSetting.timeIntervalHeight,
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
