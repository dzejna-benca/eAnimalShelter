class VolunteerAssignment {
  final int assignmentId;
  final int activityId;
  final String? activityTitle;
  final DateTime appliedAt;
  final int status;
  final String? applicationNote;
  final double hoursWorked;
  final String? adminResponseReason;
  final DateTime? activityStartDateTime;

  VolunteerAssignment({
    required this.assignmentId,
    required this.activityId,
    required this.activityTitle,
    required this.appliedAt,
    required this.status,
    required this.applicationNote,
    required this.hoursWorked,
    required this.adminResponseReason,
    this.activityStartDateTime
  });

  factory VolunteerAssignment.fromJson(
      Map<String, dynamic> json) {
    return VolunteerAssignment(
      assignmentId: json["assignmentId"],
      activityId: json["activityId"],
      activityTitle: json["activityTitle"],
      appliedAt: DateTime.parse(json["appliedAt"]),
      status: json["status"],
      applicationNote: json["applicationNote"],
      hoursWorked:
          (json["hoursWorked"] as num).toDouble(),
      adminResponseReason:
          json["adminResponseReason"],
      activityStartDateTime:
    json["activityStartDateTime"] == null
        ? null
        : DateTime.parse(
            json["activityStartDateTime"],
          ),
    );
  }
}