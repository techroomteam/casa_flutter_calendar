import 'casa_time_of_day.dart';

class CasaIssue {
  final String name;
  CasaIssue(this.name);
}

class Job {
  final String? id;
  final String? description;
  final String? unitAddress;
  final int jobDurationInHours;
  final double? jobWage;
  final DateTime? startTime;
  final CasaIssue? issue;
  // availablity list of renter, freelancer need to choose time from this list
  final List<AvailabilityTime>? availabilityList;
  final JobFreelancerActivity? freelancerActivity;

  const Job({
    this.id,
    this.description,
    this.unitAddress,
    this.startTime,
    this.jobDurationInHours = 3,
    this.jobWage,
    this.issue,
    this.freelancerActivity,
    required this.availabilityList,
  });

  Job copyWith({
    String? id,
    DateTime? startTime,
    String? description,
    String? unitAddress,
    int? jobDurationInHours,
    double? jobWage,
    List<AvailabilityTime>? availabilityList,
    JobFreelancerActivity? freelancerActivity,
    CasaIssue? issue,
  }) {
    return Job(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      description: description ?? this.description,
      unitAddress: unitAddress ?? this.unitAddress,
      jobDurationInHours: jobDurationInHours ?? this.jobDurationInHours,
      jobWage: jobWage ?? this.jobWage,
      availabilityList: availabilityList ?? this.availabilityList,
      freelancerActivity: freelancerActivity ?? this.freelancerActivity,
      issue: issue ?? this.issue,
    );
  }
}

class JobFreelancerActivity {
  // AppUser freelancer;
  DateTime? scheduleJobTime;
  DateTime? startTravelTime;
  DateTime? arrivalTime;
  String? freelancerSelfie;
  DateTime? startJobTime;
  String? failedReason;
  // List<LatLng>? technicianRoute;

  JobFreelancerActivity({
    // required this.freelancer,
    this.scheduleJobTime,
    this.startTravelTime,
    this.arrivalTime,
    this.freelancerSelfie,
    this.startJobTime,
    this.failedReason,
    // this.technicianRoute,
  });

  JobFreelancerActivity copyWith({
    // AppUser? freelancer,
    DateTime? scheduleJobTime,
    DateTime? startTravelTime,
    DateTime? arrivalTime,
    String? freelancerSelfie,
    DateTime? startJobTime,
    String? failedReason,
    // List<LatLng>? technicianRoute,
  }) {
    return JobFreelancerActivity(
      // freelancer: freelancer ?? this.freelancer,
      scheduleJobTime: scheduleJobTime ?? this.scheduleJobTime,
      startTravelTime: startTravelTime ?? this.startTravelTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      freelancerSelfie: freelancerSelfie ?? this.freelancerSelfie,
      startJobTime: startJobTime ?? this.startJobTime,
      failedReason: failedReason ?? this.failedReason,
      // technicianRoute: technicianRoute ?? this.technicianRoute,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'freelancer': freelancer.expertFreelancerToMap(),
      'scheduleJobTime': scheduleJobTime,
      'startTravelTime': startTravelTime,
      'arrivalTime': arrivalTime,
      'freelancerSelfie': freelancerSelfie,
      'startJobTime': startJobTime,
      'failedReason': failedReason,
      // 'technicianRoute': technicianRoute != null
      //     ? technicianRoute!.map((latlng) => latlngToMap(latlng)).toList()
      //     : [],
    };
  }

  factory JobFreelancerActivity.fromMap(Map<String, dynamic> map) {
    return JobFreelancerActivity(
      // freelancer: AppUser.fromMap(map['freelancer'] as Map<String, dynamic>),
      scheduleJobTime: map['scheduleJobTime'] != null
          ? map['scheduleJobTime']!.toDate()
          : null,
      startTravelTime: map['startTravelTime'] != null
          ? map['startTravelTime']!.toDate()
          : null,
      arrivalTime:
          map['arrivalTime'] != null ? map['arrivalTime']!.toDate() : null,
      freelancerSelfie: map['freelancerSelfie'] != null
          ? map['freelancerSelfie'] as String
          : null,
      startJobTime:
          map['startJobTime'] != null ? map['startJobTime']!.toDate() : null,
      failedReason:
          map['failedReason'] != null ? map['failedReason'] as String : null,
      // technicianRoute: List<LatLng>.from(
      //   map['technicianRoute']
      //           ?.map((item) => LatLng(item['latitude'], item['longitude'])) ??
      //       [],
      // ),
    );
  }

  @override
  bool operator ==(covariant JobFreelancerActivity other) {
    if (identical(this, other)) return true;

    return
        // other.freelancer == freelancer &&
        other.scheduleJobTime == scheduleJobTime &&
            other.startTravelTime == startTravelTime &&
            other.arrivalTime == arrivalTime &&
            other.freelancerSelfie == freelancerSelfie &&
            other.startJobTime == startJobTime &&
            other.failedReason == failedReason;
  }

  @override
  int get hashCode {
    return
        // freelancer.hashCode ^
        scheduleJobTime.hashCode ^
            startTravelTime.hashCode ^
            arrivalTime.hashCode ^
            freelancerSelfie.hashCode ^
            startJobTime.hashCode ^
            failedReason.hashCode;
  }

  // latlngToMap(LatLng latLng) {
  //   return {
  //     'latitude': latLng.latitude,
  //     'longitude': latLng.longitude,
  //   };
  // }
}
