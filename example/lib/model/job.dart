import 'casa_time_of_day.dart';

class Job {
  final String? id;
  final String? description;
  final String? unitAddress;
  final int numberOfHours;
  final DateTime? startTime;
  // availablity list of renter, freelancer need to choose time from this list
  final List<AvailabilityTime>? availabilityList;

  const Job({
    this.id,
    this.description,
    this.unitAddress,
    this.startTime,
    this.numberOfHours = 3,
    required this.availabilityList,
  });

  Job copyWith({
    String? id,
    DateTime? startTime,
    String? description,
    String? unitAddress,
    int? numberOfHours,
    List<AvailabilityTime>? availabilityList,
  }) {
    return Job(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      description: description ?? this.description,
      unitAddress: unitAddress ?? this.unitAddress,
      numberOfHours: numberOfHours ?? this.numberOfHours,
      availabilityList: availabilityList ?? this.availabilityList,
    );
  }
}
