// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignedTechnician {
  // final AppUser user;
  final DateTime scheduleTime;
  AssignedTechnician({
    // required this.user,
    required this.scheduleTime,
  });

  AssignedTechnician copyWith({
    // AppUser? user,
    DateTime? scheduleTime,
  }) {
    return AssignedTechnician(
      // user: user ?? this.user,
      scheduleTime: scheduleTime ?? this.scheduleTime,
    );
  }

  @override
  String toString() => 'AssignedTechnician(scheduleTime: $scheduleTime)';

  @override
  bool operator ==(covariant AssignedTechnician other) {
    if (identical(this, other)) return true;

    return other.scheduleTime == scheduleTime;
  }

  @override
  int get hashCode => scheduleTime.hashCode;
}
