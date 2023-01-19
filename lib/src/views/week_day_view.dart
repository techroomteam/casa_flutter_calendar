import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';
import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/date_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notification_counter_view.dart';

class CalendarDaysListView extends StatelessWidget {
  final DaysHeaderViewSetting daysHeaderViewSetting;
  final Function(DateTime)? onNewSelection;
  final DateTime activeDate;
  final List<CalendarAppointment> appointmentsList;
  const CalendarDaysListView({
    required this.daysHeaderViewSetting,
    required this.onNewSelection,
    required this.activeDate,
    this.appointmentsList = const [],
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: daysHeaderViewSetting.headerHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ListView.builder(
          controller: ScrollController(keepScrollOffset: false),
          scrollDirection: Axis.horizontal,
          itemCount: daysHeaderViewSetting.numberOfDays,
          itemBuilder: (BuildContext context, int index) {
            final date = DateTime(now.year, now.month, now.day + index);
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: WeekDayItemView(
                activeViewDate: activeDate.dateToYMDTime(),
                // activeDate != null ?
                // DateTime(
                //     activeDate!.year, activeDate!.month, activeDate!.day),
                // : DateTime(now.year, now.month, now.day),
                dateTime: date,
                availableDaysList: daysHeaderViewSetting.activeDaysList,
                daysHeaderViewSetting: daysHeaderViewSetting,
                jobCount: getAppointmentCountFromAppointmentList(
                    appointmentsList, date),
                onTap: onNewSelection,
              ),
            );
          },
        ),
      ),
    );
  }
}

class WeekDayItemView extends StatelessWidget {
  final DateTime activeViewDate;
  final DateTime dateTime;
  final int jobCount;
  final List<String> availableDaysList;
  final DaysHeaderViewSetting daysHeaderViewSetting;
  final Function(DateTime)? onTap;
  const WeekDayItemView({
    required this.activeViewDate,
    required this.dateTime,
    required this.availableDaysList,
    required this.daysHeaderViewSetting,
    this.jobCount = 0,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentDay = activeViewDate == dateTime;
    bool isDayAvailable =
        availableDaysList.contains(DateFormat('EEE').format(dateTime));

    final decoration = BoxDecoration(
      color: isCurrentDay
          ? daysHeaderViewSetting.activeDayColor
          : daysHeaderViewSetting.inActiveDayColor,
      borderRadius: BorderRadius.circular(12),
    );

    final color = isCurrentDay
        ? daysHeaderViewSetting.activeViewTextColor
        : isDayAvailable
            ? daysHeaderViewSetting.inActiveViewTextColor
            : daysHeaderViewSetting.disableDayViewTextColor;

    final textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
    );

    return GestureDetector(
      onTap: () => (isDayAvailable && onTap != null) ? onTap!(dateTime) : null,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              height: 88,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: decoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(dateTime),
                    style: textStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM').format(dateTime),
                    style: textStyle.copyWith(
                      color: isCurrentDay
                          ? Colors.white
                          : isDayAvailable
                              ? const Color(0xff757A8A)
                              : daysHeaderViewSetting.disableDayViewTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime.day.toString(),
                    style: textStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  daysHeaderViewSetting.showNotificationCounter && jobCount > 0,
              child: Positioned(
                right: 0,
                child: NotificationCounterView(
                  count: jobCount,
                  backgroundColor: isCurrentDay
                      ? daysHeaderViewSetting.activeDayColor
                      : const Color(0xffD2D5DF),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

int getAppointmentCountFromAppointmentList(
    List<CalendarAppointment> appointmentList, DateTime activeDate) {
  final appList = appointmentList.where((app) {
    // debugPrint("startTime: ${app.startTime?.dateToYMDTime()}");
    // debugPrint("activeDate: ${activeDate.dateToYMDTime()}");
    final appTime = app.startTime?.dateToYMDTime();
    final activeTime = activeDate.dateToYMDTime();
    return appTime!.isAtSameMomentAs(activeTime);
  });

  // debugPrint('appLIst length: ${appList.length}');
  return appList.length;
}
