import 'dart:convert';
import 'package:example/enum/day_availability.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CasaTimeOfDay extends TimeOfDay {
  const CasaTimeOfDay({required int hour, required int minute})
      : super(hour: hour, minute: minute);

  Map<String, dynamic> toMap() {
    return {'hour': hour, 'minute': minute};
  }

  String formatHM() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat("HH:mm").format(dt);
  }

  String formatHMtoUTC() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute).toUtc();
    return DateFormat("HH:mm").format(dt);
  }

  String formateHalfHourGap({bool withGap = true}) {
    final now = DateTime.now();
    final dt1 = DateTime(now.year, now.month, now.day, hour, minute);
    final dt2 = DateTime(now.year, now.month, now.day, hour, minute + 30);
    if (!withGap) {
      return "${DateFormat("HH:mm").format(dt1)}-${DateFormat("HH:mm").format(dt2)}";
    } else {
      return "${DateFormat("HH:mm").format(dt1)} - ${DateFormat("HH:mm").format(dt2)}";
    }
  }

  CasaTimeOfDay.fromMap(map) : super(hour: map['hour'], minute: map['minute']);
}

class AvailabilityTime {
  final List<String> days;
  final CasaTimeOfDay? fromTime;
  final CasaTimeOfDay? toTime;
  // enum
  final DayAvailability? dayAvailability;

  const AvailabilityTime(
      {this.days = const [], this.fromTime, this.toTime, this.dayAvailability});

  // AvailabilityTime.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data());

  AvailabilityTime copyWith({
    List<String>? days,
    CasaTimeOfDay? fromTime,
    CasaTimeOfDay? toTime,
    DayAvailability? dayAvailability,
  }) {
    return AvailabilityTime(
      days: days ?? this.days,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      dayAvailability: dayAvailability ?? this.dayAvailability,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'days': days,
      'fromTime': fromTime?.toMap(),
      'toTime': toTime?.toMap(),
      'dayAvailability': dayAvailability?.name,
    };
  }

  factory AvailabilityTime.fromMap(map) {
    return AvailabilityTime(
      days: List<String>.from((map['days'])),
      fromTime: map['fromTime'] != null
          ? CasaTimeOfDay.fromMap(map['fromTime'] as Map<String, dynamic>)
          : null,
      toTime: map['toTime'] != null
          ? CasaTimeOfDay.fromMap(map['toTime'] as Map<String, dynamic>)
          : null,
      dayAvailability: map['dayAvailability'] != null
          ? dayAvailabilityFromString(map['dayAvailability'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailabilityTime.fromJson(String source) =>
      AvailabilityTime.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvailabilityTime(days: $days, fromTime: $fromTime, toTime: $toTime, dayAvailability: $dayAvailability)';
  }

  @override
  bool operator ==(covariant AvailabilityTime other) {
    if (identical(this, other)) return true;

    return listEquals(other.days, days) &&
        other.fromTime == fromTime &&
        other.toTime == toTime &&
        other.dayAvailability == dayAvailability;
  }

  @override
  int get hashCode {
    return days.hashCode ^
        fromTime.hashCode ^
        toTime.hashCode ^
        dayAvailability.hashCode;
  }
}
