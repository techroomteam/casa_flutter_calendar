import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';
import 'package:flutter/material.dart';

class UnScheduleJobView extends StatelessWidget {
  final CalendarAppointment? unscheduleAppointmentObject;
  final CalendarAppointment selectedAppointment;
  final Widget Function(
          BuildContext, CalendarAppointment, CalendarAppointment, Key?)
      appointmentBuilder;
  const UnScheduleJobView({
    required this.unscheduleAppointmentObject,
    required this.appointmentBuilder,
    required this.selectedAppointment,
    Key? key,
  }) : super(key: key);

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
              appointmentBuilder(context, unscheduleAppointmentObject!,
                  selectedAppointment, null),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
