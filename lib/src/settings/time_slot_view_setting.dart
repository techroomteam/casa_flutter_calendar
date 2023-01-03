import 'package:flutter/material.dart';

class TimeSlotViewSettings {
  final double startHour;
  final double endHour;
  final DateTime? availableStartTime;
  final DateTime? availableEndTime;
  final String timeFormat;
  final Duration timeInterval;
  final double timeIntervalHeight;
  final TextStyle? timeTextStyle;

  const TimeSlotViewSettings({
    this.startHour = 0,
    this.endHour = 24,
    this.availableStartTime,
    this.availableEndTime,
    this.timeFormat = 'h a',
    this.timeInterval = const Duration(minutes: 60),
    this.timeIntervalHeight = 80,
    this.timeTextStyle,
  });
}
