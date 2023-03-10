import 'package:example/model/job.dart';
import 'package:example/utils/colors.dart';
import 'package:example/utils/constants.dart';
import 'package:example/utils/styles.dart';
import 'package:flutter/material.dart';

class AppointmentView extends StatelessWidget {
  final Job jobInfo;
  final double height;
  final double padding;
  final Color color;
  final Color textColor;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AppointmentView({
    required this.jobInfo,
    this.height = 80.0,
    this.padding = 2.0,
    this.color = appointmentBGColor,
    this.textColor = blackAccent1,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: EdgeInsets.all(padding),
      child: Container(
        height: height,
        padding: const EdgeInsets.only(left: 10, top: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 32,
                height: 32,
                color: Colors.redAccent,
              ),
            ),
            // Sized Box...
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   jobInfo.id ?? '',
                      //   style: bodyText3.copyWith(
                      //     fontWeight: FontWeight.w600,
                      //     color: textColor,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),

                      const SizedBox(width: 6),
                      // const Spacer(),
                      // // Sized Box...
                      // const SizedBox(width: 140),
                      // Time Container...
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: blackAccent3,
                              borderRadius:
                                  BorderRadius.circular(borderRadius7),
                            ),
                            child: Text(
                              '7am-12pm',
                              style: bodyText5.copyWith(
                                fontWeight: FontWeight.w500,
                                color: blackAccent1,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          // Sized Box...
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: appAmountColor,
                              borderRadius:
                                  BorderRadius.circular(borderRadius7),
                            ),
                            child: Text(
                              '\$1400',
                              style: bodyText5.copyWith(
                                fontWeight: FontWeight.w500,
                                color: blackAccent1,
                                fontSize: 10.0,
                              ),
                            ),
                          ),

                          // Sized Box...
                          const SizedBox(width: 6),
                        ],
                      ),
                      // const SizedBox(width: 12),
                    ],
                  ),
                ),
                Text(
                  jobInfo.description ?? '',
                  style: bodyText2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  jobInfo.property?.address.addressString ?? '',
                  style: bodyText3.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
