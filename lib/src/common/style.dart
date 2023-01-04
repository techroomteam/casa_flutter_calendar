import 'package:flutter/material.dart';

const timeTextColor = Color(0xff3C4549);
const unAvailableTimeTextColor = Color(0xffECEEF5);
const timeSlotLineColor = Color(0xffECEEF5);

const blackAccent1 = Color(0xff3C4549);
const Color blackAccent2 = Color(0xff757A8A);
Color blackAccent3 = const Color(0xffD2D5DF);

//background color
Color backgroundAccentColor = const Color(0xffF4F6FA);

// appointment view colors
const appointmentBGColor = Color(0xffF2F3F8);

/// appoinment amount baground color
Color appAmountColor = const Color(0xffFFBE18);

const Color selectedAppointmentColor = Color(0xff7B4CEB);
const Color appBackgroundColor = Color(0xffF2F3F8);

class CfCalendarStyle {
  static TextStyle timeTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: timeTextColor,
    fontSize: 12,
  );
// textstyles
  static const bodyText1 = TextStyle(fontSize: 16, color: blackAccent2);
  static const bodyText2 = TextStyle(fontSize: 14, color: blackAccent2);
  static const bodyText3 = TextStyle(fontSize: 12, color: blackAccent2);
  static const bodyText4 = TextStyle(fontSize: 11, color: blackAccent2);
  static const bodyText5 = TextStyle(fontSize: 10, color: blackAccent2);
  static const bodyText6 = TextStyle(fontSize: 18, color: blackAccent2);
  static const bodyText7 = TextStyle(fontSize: 13, color: blackAccent2);
}
