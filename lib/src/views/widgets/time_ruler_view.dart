import 'package:casa_flutter_calendar/src/common/calendar_view_helper.dart';
import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      // debugPrint("minute: $minute");
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

      // debugPrint("currentDate: $currentDate");

      final String time =
          DateFormat(timeSlotViewSettings.timeFormat).format(currentDate);
      String anteMeridiem = DateFormat('a').format(currentDate);
      // debugPrint("time: $time");
      const fontSize = 12.0;
      final Text textWidget = Text(
        time,
        style: timeTextStyle.copyWith(
          color: isInAvailableArea ? timeTextColor : unAvailableTimeTextColor,
          fontSize: fontSize,
        ),
      );
      final anteMeridiemText = Text(
        anteMeridiem,
        style: timeTextStyle.copyWith(
          color: isInAvailableArea ? timeTextColor : unAvailableTimeTextColor,
          fontSize: fontSize,
        ),
      );
      children.add(
        SizedBox(
          height: timeSlotViewSettings.timeIntervalHeight,
          child: Column(
            children: [
              textWidget,
              const SizedBox(height: 4),
              anteMeridiemText,
            ],
          ),
        ),
      );
    }

    return Column(children: children);
  }
}
