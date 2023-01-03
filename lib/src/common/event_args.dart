import 'package:flutter/material.dart';

@immutable
class AppointmentDragDetails {
  final Object? appointment;
  final Offset? draggingPosition;
  final DateTime? draggingTime;

  const AppointmentDragDetails(
    this.appointment,
    this.draggingPosition,
    this.draggingTime,
  );
}
