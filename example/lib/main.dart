import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';
import 'package:example/enum/date_extension.dart';
import 'package:example/model/job.dart';
import 'package:example/utils/colors.dart';
import 'package:flutter/material.dart';

import 'enum/day_availability.dart';
import 'model/casa_time_of_day.dart';
import 'views/appointment_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CasaFlutterCalendarExample(),
    );
  }
}

class CasaFlutterCalendarExample extends StatefulWidget {
  const CasaFlutterCalendarExample({Key? key}) : super(key: key);

  @override
  State<CasaFlutterCalendarExample> createState() =>
      _CasaFlutterCalendarExampleState();
}

// constants declare here
double timeIntervalHeight = 80;
final now = DateTime.now();

class _CasaFlutterCalendarExampleState
    extends State<CasaFlutterCalendarExample> {
  DateTime activeDate = now;
  late AvailabilityTime selectedJobAvailability;
  DateTime? availableStartTime;
  DateTime? availableEndTime;
  // selected job
  late var unscheduleJob = Job(
    id: 'Ticket 900',
    description: 'Washing machine not starting',
    jobDurationInHours: 2,
    availabilityList: [
      const AvailabilityTime(
        days: ['Mon'],
        dayAvailability: DayAvailability.morning,
        fromTime: CasaTimeOfDay(hour: 7, minute: 0),
        toTime: CasaTimeOfDay(hour: 12, minute: 0),
      ),
      const AvailabilityTime(
        days: ['Tue', 'Thu'],
        dayAvailability: DayAvailability.noon,
        fromTime: CasaTimeOfDay(hour: 7, minute: 0),
        toTime: CasaTimeOfDay(hour: 17, minute: 0),
      ),
    ],
    // freelancerActivity: JobFreelancerActivity(
    //   scheduleJobTime: DateTime(now.year, now.month, now.day, 12),
    // ),
  );
  //
  late CalendarAppointment unScheduleAppointment =
      createAppointment(unscheduleJob);
  // late CalendarAppointment selectedAppointment = unScheduleAppointment;
  // already scheduled job list
  final myScheduleJobsListProvider = [
    Job(
      id: 'Ticket 786',
      description: 'Washing machine not starting',
      jobDurationInHours: 2,
      startTime: DateTime(now.year, now.month, now.day + 1, 1),
      availabilityList: const [
        AvailabilityTime(
          days: ['Tue'],
          dayAvailability: DayAvailability.noon,
          fromTime: CasaTimeOfDay(hour: 12, minute: 0),
          toTime: CasaTimeOfDay(hour: 20, minute: 0),
        ),
        AvailabilityTime(
          days: ['Wed', 'Thu'],
          dayAvailability: DayAvailability.morning,
          fromTime: CasaTimeOfDay(hour: 4, minute: 0),
          toTime: CasaTimeOfDay(hour: 12, minute: 0),
        ),
      ],
      freelancerActivity: JobFreelancerActivity(
          scheduleJobTime: DateTime(now.year, now.month, now.day + 1, 1)),
    ),
    Job(
      id: 'Ticket 800',
      description: 'Washing machine not starting',
      jobDurationInHours: 3,
      startTime: DateTime(now.year, now.month, now.day, 17),
      availabilityList: const [
        AvailabilityTime(
          days: ['Tue'],
          dayAvailability: DayAvailability.morning,
          fromTime: CasaTimeOfDay(hour: 0, minute: 0),
          toTime: CasaTimeOfDay(hour: 24, minute: 0),
        ),
        AvailabilityTime(
          days: ['Wed', 'Thu'],
          dayAvailability: DayAvailability.noon,
          fromTime: CasaTimeOfDay(hour: 12, minute: 0),
          toTime: CasaTimeOfDay(hour: 23, minute: 0),
        ),
      ],
      freelancerActivity: JobFreelancerActivity(
          scheduleJobTime: DateTime(now.year, now.month, now.day, 12)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: const Text('Schedule', style: TextStyle(color: Colors.black)),
      leading: const BackButton(color: Colors.black),
      elevation: 0.0,
    );
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    var appBarHeight = appBar.preferredSize.height;
    var extraHeight = statusBarHeight + appBarHeight;

    return Scaffold(
      appBar: appBar,
      body: CfCalendar(
        timeSlotViewSetting: TimeSlotViewSettings(
          timeIntervalHeight: timeIntervalHeight,
          timeInterval: const Duration(minutes: 30),
          timeFormat: 'hh:mm',
        ),
        daysHeaderViewSetting: DaysHeaderViewSetting(
            extraHeight: extraHeight, showNotificationCounter: true),
        dataSource: MeetingDataSource(_getDataSource()),
        // unScheduleAppointment: unScheduleAppointment,
        activeDate: activeDate,
        //   appointmentBuilder:
        //       (context, appointment, selectedAppointment, key) {
        //     Job job = appointment.data as Job;
        //     debugPrint("selectedAppointment: ${selectedAppointment.id}");
        //     debugPrint("appointment: ${appointment.id}");
        //     bool isSelectedJob = selectedAppointment.id == appointment.id;
        //     debugPrint("isSelectedJob: $isSelectedJob");
        //     return AppointmentView(
        //       key: key,
        //       height:
        //           isSelectedJob ? 80 : timeIntervalHeight * job.numberOfHours,
        //       jobInfo: job,
        //       color: isSelectedJob ? primaryColor : appBackgroundColor,
        //       textColor: isSelectedJob ? Colors.white : blackAccent1,
        //     );
        //   },
        // ),
        // ],
        onAccept: (acceptedAppointment, scheduleDate) {
          debugPrint("onAccept");
        },
        onJobScheduleChange: (jobID, newScheduleTime) {
          debugPrint("JOBID: $jobID");
          debugPrint("newScheduleTime: $newScheduleTime");
        },
        onAppointmentTap: (jobID) {},
      ),
    );
  }

  List<Job> _getDataSource() {
    return myScheduleJobsListProvider;
    // final List<Job> jobs = <Job>[];
    // jobs.add(
    //   Job(
    //     id: 'id',
    //     description: 'description',
    //     unitAddress: 'unit address',
    //     numberOfHours: 2,
    //     startTime: DateTime(now.year, now.month, now.day, 5),
    //   ),
    // );
    // jobs.add(
    //   Job(
    //     id: 'id 2',
    //     description: 'description 2',
    //     unitAddress: 'unit address 2',
    //     numberOfHours: 4,
    //     startTime: DateTime(now.year, now.month, now.day, 13),
    //   ),
    // );
    // return jobs;
  }

  CalendarAppointment createAppointment(Job activeJobObject) {
    var app = CalendarAppointment(id: activeJobObject.id);
    app.data = activeJobObject;

    return app;
  }
}

/// TEST DATA

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Job> source) {
    appointments = source;
  }

  @override
  String? getId(int index) => _getMeetingData(index).id;

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).startTime ?? now;
  }

  @override
  DateTime getEndTime(int index) {
    final date = _getMeetingData(index).startTime;
    if (date == null) {
      return now;
    } else {
      final numOfHour = _getMeetingData(index).jobDurationInHours;
      return DateTime(date.year, date.month, date.day, date.hour + numOfHour);
    }
  }

  // @override
  // Color getColor(int index) {
  //   return _getMeetingData(index).;
  // }

  Job _getMeetingData(int index) {
    final dynamic job = appointments[index];
    late final Job jobData;
    if (job is Job) {
      jobData = job;
    }

    return jobData;
  }
}
