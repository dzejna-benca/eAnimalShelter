class VolunteerActivityDetails {
  final int activityId;
  final String title;
  final String description;
  final String locationName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int maxVolunteers;
  final int status;
  final String createdByUserName;
  final bool isApplied;

  VolunteerActivityDetails({
    required this.activityId,
    required this.title,
    required this.description,
    required this.locationName,
    required this.startDateTime,
    required this.endDateTime,
    required this.maxVolunteers,
    required this.status,
    required this.createdByUserName,
    required this.isApplied
  });

  factory VolunteerActivityDetails.fromJson(
      Map<String, dynamic> json) {
    return VolunteerActivityDetails(
      activityId: json["activityId"],
      title: json["title"],
      description: json["description"],
      locationName: json["locationName"],
      startDateTime:
          DateTime.parse(json["startDateTime"]),
      endDateTime:
          DateTime.parse(json["endDateTime"]),
      maxVolunteers: json["maxVolunteers"],
      status: json["status"],
      createdByUserName:
          json["createdByUserName"],
      isApplied: json["isApplied"] ?? false,
    );
  }
}