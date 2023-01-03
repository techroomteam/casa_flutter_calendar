import 'package:flutter/material.dart';

abstract class CalendarDataSource<T extends Object?> {
  List<dynamic> appointments = [];
  DateTime getStartTime(int index) => DateTime.now();
  DateTime getEndTime(int index) => DateTime.now();
  Color getColor(int index) => Colors.lightBlue;
  String getSubject(int index) => '';
  Object? getId(int index) => null;
}
