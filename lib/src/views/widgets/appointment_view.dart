import 'package:casa_flutter_calendar/src/common/calendar_view_helper.dart';
import 'package:casa_flutter_calendar/src/common/constants.dart';
import 'package:casa_flutter_calendar/src/common/style.dart';
import 'package:flutter/material.dart';

// class Job {
//   final String id;
//   final AppUser createdBy;
//   final DateTime createdAt;
//   final CasaIssue issue;
//   final String description;
//   final double? jobWage;

//   // enum
//   final JobStatus status;
//   final List<CasaAttachment> attachments;
//   final String? voiceNote;
//   // final String? unitAddress;

//   // enum
//   final JobType type;
//   final int? jobDurationInHours;
//   final bool residentWillResolveWorkHimSelf;

//   // enum
//   final UserRole? jobRequiredSkill;

//   // availablity list of renter, freelancer need to choose time from this list
//   final List<AvailabilityTime>? availabilityList;
//   final Meeting? meetingActivity;
//   final List<JobActivity> activities;

//   ///
//   final OnTheWay? lastOnTheWayActivity;

//   /// this parameter will hold freelancer, renter, expert feedback
//   final JobFeedback? feedback;

//   /// this map will hold, assigned freelanceer and it's assinged date
//   final AssignedTechnician? assignedTechnician;

//   /// Property
//   final Property property;

//   /// Job Tool List
//   final List<JobTool>? jobToolsList;

//   /// Required Technician Level List...
//   final List<String>? requiredTechnicianLevel;
// }

class AppointmentView extends StatelessWidget {
  final jobInfo;
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        key: key,
        padding: EdgeInsets.all(padding),
        child: Stack(
          children: [
            Container(
              height: height,
              width: MediaQuery.of(context).size.width / 1.18,
              padding: const EdgeInsets.only(left: 10, top: 14, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    jobInfo.issue?.image ?? electricApplianceAsset,
                    width: 32,
                    height: 32,
                  ),

                  // Sized Box...
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        // width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          jobInfo.id,
                          style: CfCalendarStyle.bodyText3.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 8.0),
                      Text(
                        jobInfo.issue?.name ?? '',
                        style: CfCalendarStyle.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        jobInfo.property.address.addressString,
                        style: CfCalendarStyle.bodyText3.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  jobInfo.assignedTechnician == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: blackAccent3,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              CalendarViewHelper.getAvailabilityTimeOfDay(
                                  jobInfo.availabilityList,
                                  jobInfo.assignedTechnician?.scheduleTime),
                              style: CfCalendarStyle.bodyText5.copyWith(
                                fontWeight: FontWeight.w500,
                                color: blackAccent1,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                  // Sized Box...
                  const SizedBox(width: 8),
                  jobInfo.jobWage == null
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: appAmountColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '\$${jobInfo.jobWage}',
                            style: CfCalendarStyle.bodyText5.copyWith(
                              fontWeight: FontWeight.w500,
                              color: blackAccent1,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
