enum DayAvailability { morning, noon, night, fullday, custom }

DayAvailability dayAvailabilityFromString(String status) {
  if (status == 'Morning') {
    return DayAvailability.morning;
  } else if (status == 'Noon') {
    return DayAvailability.noon;
  } else if (status == 'Night') {
    return DayAvailability.night;
  } else {
    return DayAvailability.fullday;
  }
}

dayAvailabilityToString(DayAvailability status) {
  if (status == DayAvailability.morning) {
    return 'Morning';
  } else if (status == DayAvailability.noon) {
    return 'Noon';
  } else if (status == DayAvailability.night) {
    return 'Night';
  } else if (status == DayAvailability.fullday) {
    return 'FullDay';
  } else {
    return 'Custom';
  }
}
