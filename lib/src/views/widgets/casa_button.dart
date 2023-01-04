import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CasaButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Size? size;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Gradient? gradient;
  // final TextStyle textStyle;
  final double? elevation;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final double? radius;
  const CasaButton({
    required this.text,
    this.icon,
    this.size,
    this.padding,
    this.onPressed,
    this.backgroundColor = selectedAppointmentColor,
    this.gradient,
    this.elevation,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w500,
    this.radius,
    // this.textStyle = const TextStyle(
    //   fontSize: 16,
    //   color: blackAccent2,
    //   fontWeight: FontWeight.w500,
    // ),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // primary: backgroundColor,
          // onSurface: backgroundColor,
          minimumSize: size ?? const Size(132, 48),
          padding: padding,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
        ),
        child: icon ??
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
      ),
    );
  }
}
