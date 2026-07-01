class VolunteerAssignment {
  int? assignmentId;
  int? userId;
  String? userName;

  int? activityId;
  String? activityTitle;

  DateTime? appliedAt;

  String? applicationNote;
  int? status;

  double? hoursWorked;

  String? email;
  String? phoneNumber;
  String? adminResponseReason;

  VolunteerAssignment({
    this.assignmentId,
    this.userId,
    this.userName,
    this.activityId,
    this.activityTitle,
    this.appliedAt,
    this.applicationNote,
    this.status,
    this.hoursWorked,
    this.email,
    this.phoneNumber,
    this.adminResponseReason
  });

  factory VolunteerAssignment.fromJson(
    Map<String, dynamic> json,
  ) {
    return VolunteerAssignment(
      assignmentId: json["assignmentId"],
      userId: json["userId"],
      userName: json["userName"],
      activityId: json["activityId"],
      activityTitle: json["activityTitle"],
      appliedAt: json["appliedAt"] != null
          ? DateTime.parse(json["appliedAt"])
          : null,
      applicationNote: json["applicationNote"],
      status: json["status"],
      hoursWorked:
          (json["hoursWorked"] ?? 0).toDouble(),
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      adminResponseReason: json["adminResponseReason"]
    );
  }
}