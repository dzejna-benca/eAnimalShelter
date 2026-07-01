class VolunteerActivity {
  int activityId;
  String? title;
  String? description;

  int? locationId;
  String? locationName;

  DateTime? startDateTime;
  DateTime? endDateTime;

  int? maxVolunteers;
  int? currentVolunteers;

  int? status;

  int? createdBy;
  String? createdByUserName;
  int? applicationsCount;

  VolunteerActivity({
    required this.activityId,
    this.title,
    this.description,
    this.locationId,
    this.locationName,
    this.startDateTime,
    this.endDateTime,
    this.maxVolunteers,
    this.currentVolunteers,
    this.status,
    this.createdBy,
    this.createdByUserName,
    this.applicationsCount
  });

  factory VolunteerActivity.fromJson(
    Map<String, dynamic> json,
  ) {
    return VolunteerActivity(
      activityId: json["activityId"],
      title: json["title"],
      description: json["description"],
      locationId: json["locationId"],
      locationName: json["locationName"],
      startDateTime: json["startDateTime"] != null
          ? DateTime.parse(json["startDateTime"])
          : null,
      endDateTime: json["endDateTime"] != null
          ? DateTime.parse(json["endDateTime"])
          : null,
      maxVolunteers: json["maxVolunteers"],
      currentVolunteers: json["currentVolunteers"],
      status: json["status"],
      createdBy: json["createdBy"],
      createdByUserName: json["createdByUserName"],
      applicationsCount: json["applicationsCount"],
    );
  }
}