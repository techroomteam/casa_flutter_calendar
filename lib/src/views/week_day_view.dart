import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/settings/days_header_view_setting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notification_counter_view.dart';

class CalendarDaysListView extends StatelessWidget {
  final DaysHeaderViewSetting daysHeaderViewSetting;
  final Function(DateTime)? onNewSelection;
  final DateTime? activeDate;
  const CalendarDaysListView({
    required this.daysHeaderViewSetting,
    required this.onNewSelection,
    this.activeDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: daysHeaderViewSetting.headerHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: daysHeaderViewSetting.numberOfDays,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: WeekDayItemView(
                activeViewDate: activeDate != null
                    ? DateTime(
                        activeDate!.year, activeDate!.month, activeDate!.day)
                    : DateTime(now.year, now.month, now.day),
                dateTime: DateTime(now.year, now.month, now.day + index),
                availableDaysList: daysHeaderViewSetting.activeDaysList,
                daysHeaderViewSetting: daysHeaderViewSetting,
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
  final List<String> availableDaysList;
  final DaysHeaderViewSetting daysHeaderViewSetting;
  final Function(DateTime)? onTap;
  const WeekDayItemView({
    required this.activeViewDate,
    required this.dateTime,
    required this.availableDaysList,
    required this.daysHeaderViewSetting,
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
          : const Color(0xffF2F3F8),
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
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: decoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(dateTime),
                    style: textStyle,
                  ),
                  Text(
                    DateFormat('MMM').format(dateTime),
                    style: textStyle,
                  ),
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
              visible: daysHeaderViewSetting.showNotificationCounter,
              child: Positioned(
                right: 0,
                child: NotificationCounterView(
                  count: 5,
                  backgroundColor: isCurrentDay
                      ? daysHeaderViewSetting.activeDayColor
                      : daysHeaderViewSetting.inActiveDayColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
