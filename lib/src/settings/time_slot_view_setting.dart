// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  TimeSlotViewSettings copyWith({
    double? startHour,
    double? endHour,
    DateTime? availableStartTime,
    DateTime? availableEndTime,
    String? timeFormat,
    Duration? timeInterval,
    double? timeIntervalHeight,
    TextStyle? timeTextStyle,
  }) {
    return TimeSlotViewSettings(
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      availableStartTime: availableStartTime,
      availableEndTime: availableEndTime,
      timeFormat: timeFormat ?? this.timeFormat,
      timeInterval: timeInterval ?? this.timeInterval,
      timeIntervalHeight: timeIntervalHeight ?? this.timeIntervalHeight,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
    );
  }

  @override
  String toString() {
    return 'TimeSlotViewSettings(startHour: $startHour, endHour: $endHour, availableStartTime: $availableStartTime, availableEndTime: $availableEndTime, timeFormat: $timeFormat, timeInterval: $timeInterval, timeIntervalHeight: $timeIntervalHeight, timeTextStyle: $timeTextStyle)';
  }

  @override
  bool operator ==(covariant TimeSlotViewSettings other) {
    if (identical(this, other)) return true;

    return other.startHour == startHour &&
        other.endHour == endHour &&
        other.availableStartTime == availableStartTime &&
        other.availableEndTime == availableEndTime &&
        other.timeFormat == timeFormat &&
        other.timeInterval == timeInterval &&
        other.timeIntervalHeight == timeIntervalHeight &&
        other.timeTextStyle == timeTextStyle;
  }

  @override
  int get hashCode {
    return startHour.hashCode ^
        endHour.hashCode ^
        availableStartTime.hashCode ^
        availableEndTime.hashCode ^
        timeFormat.hashCode ^
        timeInterval.hashCode ^
        timeIntervalHeight.hashCode ^
        timeTextStyle.hashCode;
  }
}
