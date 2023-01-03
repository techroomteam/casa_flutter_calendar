import 'package:flutter/material.dart';

class CalendarAppointment {
  DateTime? startTime;

  DateTime? endTime;

  /// Defaults to ` ` represents empty string.
  String subject;

  /// Defaults to `Colors.lightBlue`.
  Color color;

  /// Defaults to hashCode.
  Object? id;

  /// Holds the parent appointment details
  Object? data;

  RRect? appointmentRect;

  CalendarAppointment({
    this.startTime,
    this.endTime,
    this.appointmentRect,
    this.subject = '',
    this.color = Colors.lightBlue,
    this.id,
    this.data,
  });

  CalendarAppointment copyWith({
    DateTime? startTime,
    DateTime? endTime,
    RRect? rRect,
    String? subject,
    Color? color,
    Object? id,
    Object? data,
  }) {
    return CalendarAppointment(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      appointmentRect: rRect ?? appointmentRect,
      subject: subject ?? this.subject,
      color: color ?? this.color,
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'CalendarAppointment(startTime: $startTime, endTime: $endTime, subject: $subject, color: $color, id: $id, data: $data)';
  }

  @override
  bool operator ==(covariant CalendarAppointment other) {
    if (identical(this, other)) return true;

    return other.startTime == startTime &&
        other.endTime == endTime &&
        other.subject == subject &&
        other.color == color &&
        other.id == id &&
        other.data == data &&
        other.appointmentRect == appointmentRect;
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        subject.hashCode ^
        color.hashCode ^
        id.hashCode ^
        data.hashCode ^
        appointmentRect.hashCode;
  }
}
