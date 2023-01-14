import 'package:casa_flutter_calendar/casa_flutter_calendar.dart';

double totalExtraHeight = 0.0;

double kStatusBarHeight = 24.0;
DateTime now = DateTime.now();

// Un-Available Area
// double? unAvailableStartTime;
// double? unAvailableEndTime;
/// I declare this value as constant because we can easily use it through out the applicagtion
late TimeSlotViewSettings timeSlotViewSettings;

// assets
const electricApplianceAsset =
    "packages/casa_flutter_calendar/images/electric-appliance.png";
