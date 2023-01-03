library casa_flutter_calendar;

export 'src/views/cfcalender.dart';
export 'src/settings/time_slot_view_setting.dart';
export 'src/settings/days_header_view_setting.dart';
export 'src/model/calendar_data_source.dart';
export 'src/common/calendar_view_helper.dart';
export 'src/common/appointment_helper.dart';
export 'src/model/calendar_appointment.dart';



//
// #1: Pass [CalendarDataSource<Object?>?] data

// #2: Convert dataSource to [CasaAppointment] in initState
// #*: 