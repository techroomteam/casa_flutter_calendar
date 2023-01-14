import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';
import 'package:casa_flutter_calendar/src/common/calendar_view_helper.dart';
import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:flutter/material.dart';

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
