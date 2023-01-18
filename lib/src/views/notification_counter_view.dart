import 'package:flutter/material.dart';

class NotificationCounterView extends StatelessWidget {
  final int count;
  final Color backgroundColor;
  final Color textColor;
  const NotificationCounterView({
    this.count = 0,
    this.backgroundColor = const Color(0xffD33D3D),
    this.textColor = const Color(0xffFFFFFF),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, -10),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // borderRadius: BorderRadius.circular(9),
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            // borderRadius: BorderRadius.circular(9),
            shape: BoxShape.circle,
          ),
          // constraints: const BoxConstraints(minWidth: 21, minHeight: 20),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
