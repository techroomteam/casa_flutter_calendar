import 'package:example/model/job.dart';
import 'package:example/utils/colors.dart';
import 'package:example/utils/constants.dart';
import 'package:example/utils/styles.dart';
import 'package:flutter/material.dart';

class AppointmentView extends StatelessWidget {
  final Job jobInfo;
  final double height;
  final double padding;
  final bool inDisabledArea;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AppointmentView({
    required this.jobInfo,
    this.height = 80.0,
    this.padding = 2.0,
    this.inDisabledArea = false,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          // if (!inDisabledArea) {
          //   read(selectedJobProvider.notifier).update((state) => jobInfo);
          //   checkAvailability(ref);
          // }
        },
        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 10, top: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: inDisabledArea
                ? appointmentBGColor.withOpacity(0.4)
                : appointmentBGColor,
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
                        Text(
                          jobInfo.id ?? '',
                          style: bodyText3.copyWith(
                            fontWeight: FontWeight.w600,
                            color: blackAccent1,
                          ),
                        ),
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
                      color: blackAccent1,
                    ),
                  ),
                  Text(
                    jobInfo.unitAddress ?? '',
                    style: bodyText3.copyWith(
                      fontWeight: FontWeight.w500,
                      color: blackAccent2,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
