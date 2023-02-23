// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:example/model/property.dart';

import 'assigned_technician.dart';
import 'casa_time_of_day.dart';

class CasaIssue {
  final String name;
  CasaIssue(this.name);
}

class Job {
  final String? id;
  // final AppUser? createdBy;
  final DateTime? createdAt;
  final CasaIssue? issue;
  final String? description;
  final double? jobWage;

  // expert
  final String? expertDescription;
  final String? expertVoiceNote;

  // // enum
  // final JobStatus status;
  // final List<CasaAttachment> attachments;
  final String? voiceNote;
  // final String? unitAddress;

  // enum
  // final JobType type;
  final int? jobDurationInHours;
  final bool residentWillResolveWorkHimSelf;

  // enum
  // final UserRole? jobRequiredSkill;

  // availablity list of resident, technician need to choose time from this list
  final List<AvailabilityTime>? availabilityList;
  // final Meeting? meetingActivity;
  // final List<JobActivity>? activities;

  /// this parameter will hold technician, resident, expert feedback
  // final JobFeedback? feedback;

  /// this map will hold, assigned freelanceer and it's assinged date
  final AssignedTechnician? assignedTechnician;

  // /// job revision information
  // final JobRevision? revision;

  // /// job submission information
  // final JobSubmission? jobSubmission;

  /// Property
  final Property? property;

  /// Job Tool List
  // final List<JobTool>? jobToolsList;

  /// Required Technician Level List...
  final List<String>? requiredTechnicianLevel;

  const Job({
    this.id,
    // this.createdBy,
    this.createdAt,
    this.issue,
    this.jobWage,
    this.description,
    this.expertDescription,
    this.expertVoiceNote,
    // this.status = JobStatus.meetingwithexpert,
    // this.attachments = const [],
    this.voiceNote,
    // this.unitAddress,
    // this.type = JobType.covered,
    this.jobDurationInHours,
    this.residentWillResolveWorkHimSelf = false,
    // this.jobRequiredSkill = UserRole.plumber,
    this.availabilityList,
    // this.meetingActivity,
    // this.activities,
    // this.feedback,
    this.assignedTechnician,
    // this.revision,
    // this.jobSubmission,
    this.property,
    // this.jobToolsList = const [],
    this.requiredTechnicianLevel = const [],
  });

  Job copyWith({
    String? id,
    // AppUser? createdBy,
    DateTime? createdAt,
    CasaIssue? issue,
    String? description,
    // JobStatus? status,
    double? jobWage,
    String? expertDescription,
    String? expertVoiceNote,
    // List<CasaAttachment>? attachments,
    String? voiceNote,
    // String? unitAddress,
    // JobType? type,
    // UserRole? jobRequiredSkill,
    int? jobDurationInHours,
    bool? residentWillResolveWorkHimSelf,
    List<AvailabilityTime>? availabilityList,
    // Meeting? meetingActivity,
    // List<JobActivity>? activities,
    // JobFeedback? feedback,
    AssignedTechnician? assignedTechnician,
    // JobRevision? revision,
    // JobSubmission? jobSubmission,
    Property? property,
    // List<JobTool>? jobToolsList,
    List<String>? requiredTechnicianLevel,
  }) {
    return Job(
      id: id ?? this.id,
      // createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      issue: issue ?? this.issue,
      description: description ?? this.description,
      // jobRequiredSkill: jobRequiredSkill ?? this.jobRequiredSkill,
      jobWage: jobWage ?? this.jobWage,
      expertDescription: expertDescription ?? this.expertDescription,
      expertVoiceNote: expertVoiceNote ?? this.expertVoiceNote,
      // status: status ?? this.status,
      // attachments: attachments ?? this.attachments,
      voiceNote: voiceNote ?? this.voiceNote,
      // unitAddress: unitAddress ?? this.unitAddress,
      // type: type ?? this.type,
      jobDurationInHours: jobDurationInHours ?? this.jobDurationInHours,
      residentWillResolveWorkHimSelf:
          residentWillResolveWorkHimSelf ?? this.residentWillResolveWorkHimSelf,
      availabilityList: availabilityList ?? this.availabilityList,
      // meetingActivity: meetingActivity ?? this.meetingActivity,
      // activities: activities ?? this.activities,
      // feedback: feedback ?? this.feedback,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      // revision: revision ?? this.revision,
      // jobSubmission: jobSubmission ?? this.jobSubmission,
      property: property ?? this.property,
      // jobToolsList: jobToolsList ?? this.jobToolsList,
      requiredTechnicianLevel:
          requiredTechnicianLevel ?? this.requiredTechnicianLevel,
    );
  }

  @override
  String toString() {
    return 'Job(id: $id, createdAt: $createdAt, issue: $issue, description: $description, jobWage: $jobWage, expertDescription: $expertDescription, expertVoiceNote: $expertVoiceNote, voiceNote: $voiceNote, jobDurationInHours: $jobDurationInHours, residentWillResolveWorkHimSelf: $residentWillResolveWorkHimSelf, availabilityList: $availabilityList, assignedTechnician: $assignedTechnician, property: $property, requiredTechnicianLevel: $requiredTechnicianLevel)';
  }

  @override
  bool operator ==(covariant Job other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.issue == issue &&
        other.description == description &&
        other.jobWage == jobWage &&
        other.expertDescription == expertDescription &&
        other.expertVoiceNote == expertVoiceNote &&
        other.voiceNote == voiceNote &&
        other.jobDurationInHours == jobDurationInHours &&
        other.residentWillResolveWorkHimSelf ==
            residentWillResolveWorkHimSelf &&
        listEquals(other.availabilityList, availabilityList) &&
        other.assignedTechnician == assignedTechnician &&
        other.property == property &&
        listEquals(other.requiredTechnicianLevel, requiredTechnicianLevel);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        issue.hashCode ^
        description.hashCode ^
        jobWage.hashCode ^
        expertDescription.hashCode ^
        expertVoiceNote.hashCode ^
        voiceNote.hashCode ^
        jobDurationInHours.hashCode ^
        residentWillResolveWorkHimSelf.hashCode ^
        availabilityList.hashCode ^
        assignedTechnician.hashCode ^
        property.hashCode ^
        requiredTechnicianLevel.hashCode;
  }
}
