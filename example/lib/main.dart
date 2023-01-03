import 'dart:math';

import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';
import 'package:example/enum/date_extension.dart';
import 'package:example/model/job.dart';
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
  late DateTime availableStartTime;
  late DateTime availableEndTime;
  // selected job
  final selectedJob = Job(
    id: 'Ticket 900',
    description: 'Washing machine not starting',
    startTime: now,
    availablityList: [
      const AvailabilityTime(
        days: ['Fri'],
        dayAvailability: DayAvailability.morning,
        fromTime: CasaTimeOfDay(hour: 7, minute: 0),
        toTime: CasaTimeOfDay(hour: 12, minute: 0),
      ),
      const AvailabilityTime(
        days: ['Tue', 'Thu'],
        dayAvailability: DayAvailability.noon,
        fromTime: CasaTimeOfDay(hour: 0, minute: 0),
        toTime: CasaTimeOfDay(hour: 17, minute: 0),
      ),
    ],
  );
  CalendarAppointment? selectedJobCalendarApp;
  // already scheduled job list
  final myScheduleJobsListProvider = [
    Job(
      id: 'Ticket 786',
      description: 'Washing machine not starting',
      numberOfHours: 2,
      startTime: DateTime(now.year, now.month, now.day, 5),
      availablityList: const [
        AvailabilityTime(
          days: ['Fri'],
          dayAvailability: DayAvailability.morning,
          fromTime: CasaTimeOfDay(hour: 12, minute: 0),
          toTime: CasaTimeOfDay(hour: 7, minute: 0),
        ),
        AvailabilityTime(
          days: ['Mon', 'Thu'],
          dayAvailability: DayAvailability.noon,
          fromTime: CasaTimeOfDay(hour: 0, minute: 0),
          toTime: CasaTimeOfDay(hour: 12, minute: 0),
        ),
      ],
    ),
    Job(
      id: 'Ticket 800',
      description: 'Washing machine not starting',
      numberOfHours: 3,
      startTime: DateTime(now.year, now.month, now.day, 13),
      availablityList: const [
        AvailabilityTime(
          days: ['Fri'],
          dayAvailability: DayAvailability.morning,
          fromTime: CasaTimeOfDay(hour: 17, minute: 0),
          toTime: CasaTimeOfDay(hour: 24, minute: 0),
        ),
        AvailabilityTime(
          days: ['Mon', 'Thu'],
          dayAvailability: DayAvailability.noon,
          fromTime: CasaTimeOfDay(hour: 12, minute: 0),
          toTime: CasaTimeOfDay(hour: 24, minute: 0),
        ),
      ],
    ),
  ];

  //
  late CalendarDataSource<Object?> dataSource;
  @override
  void initState() {
    // 1:
    checkAvailability();
    // 2:
    selectedJobToCalendarAppointment();
    super.initState();
  }

  void selectedJobToCalendarAppointment() {
    var selectedJobDataSource = MeetingDataSource([selectedJob]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedJobCalendarApp = AppointmentHelper.createAppointment(
          selectedJob, selectedJobDataSource);
      setState(() {});
    });
  }

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

    debugPrint(
        'statusBarHeight: $statusBarHeight, appBarHeight: $appBarHeight');

    //
    dataSource = MeetingDataSource(_getDataSource());

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          DragTarget<CalendarAppointment>(
            onAcceptWithDetails: (details) {
              debugPrint("Details: " + details.toString());
              AppointmentHelper.onAcceptWithDetail(details, setState);
            },
            builder: (context, candidateData, rejectedData) {
              return CfCalendar(
                timeSlotViewSetting: TimeSlotViewSettings(
                  timeIntervalHeight: timeIntervalHeight,
                  availableStartTime: availableStartTime,
                  availableEndTime: availableEndTime,
                ),
                daysHeaderViewSetting: DaysHeaderViewSetting(
                  // activeDaysList: ['Tue', 'Thu', 'Fri', 'Mon'],
                  extraHeight: extraHeight,
                ),
                dataSource: MeetingDataSource(_getDataSource()),
                activeDate: activeDate,
                onViewChanged: (newDate) {
                  activeDate = newDate;
                  setState(() {});
                },
                appointmentBuilder: (context, appointment, key) {
                  Job job = appointment as Job;
                  return AppointmentView(
                    key: key,
                    height: timeIntervalHeight * job.numberOfHours,
                    jobInfo: job,
                  );
                },
              );
            },
          ),

          //selected job
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LongPressDraggable<CalendarAppointment>(
              data: selectedJobCalendarApp,
              feedback: AppointmentView(jobInfo: selectedJob),
              child: SelectedJobView(job: selectedJob),
            ),
          ),
        ],
      ),
    );
  }

  /// This method will get renter availablity of particular day from Ticket Availablity object
  void checkAvailability() {
    String selectedDay = activeDate.weekdayName()!;

    debugPrint('selectedDay: $selectedDay');

    for (var availability in selectedJob.availablityList!) {
      if (availability.days.contains(selectedDay)) {
        selectedJobAvailability = availability;
        availableStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          availability.fromTime!.hour,
          availability.fromTime!.minute,
        );
        availableEndTime = DateTime(
          now.year,
          now.month,
          now.day,
          availability.toTime!.hour,
          availability.toTime!.minute,
        );
        setState(() {});
        break;
      } else {
        debugPrint("Not Found");
      }
    }
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
    return _getMeetingData(index).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    final date = _getMeetingData(index).startTime;
    final numOfHour = _getMeetingData(index).numberOfHours;
    return DateTime(date.year, date.month, date.day, date.hour + numOfHour);
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

// SELECTED JOB
class SelectedJobView extends StatelessWidget {
  final Job job;
  const SelectedJobView({required this.job, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('To Accept job drag it to desired time first '),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GridView
              SizedBox(
                width: 16,
                height: 50,
                child: GridView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5.6,
                    crossAxisSpacing: 4.2,
                  ),
                  itemBuilder: (context, index) => Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // appointment view
              AppointmentView(jobInfo: job),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
