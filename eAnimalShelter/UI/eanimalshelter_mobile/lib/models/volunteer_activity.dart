class VolunteerActivity {
  final int activityId;
  final String title;
  final String description;
  final int locationId;
  final String? locationName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int maxVolunteers;
  final int status;
  final int currentVolunteers;
  final int applicationsCount;

  VolunteerActivity({
    required this.activityId,
    required this.title,
    required this.description,
    required this.locationId,
    required this.locationName,
    required this.startDateTime,
    required this.endDateTime,
    required this.maxVolunteers,
    required this.status,
    required this.currentVolunteers,
    required this.applicationsCount,
  });

  factory VolunteerActivity.fromJson(Map<String, dynamic> json) {
    return VolunteerActivity(
      activityId: json["activityId"],
      title: json["title"],
      description: json["description"],
      locationId: json["locationId"],
      locationName: json["locationName"],
      startDateTime: DateTime.parse(json["startDateTime"]),
      endDateTime: DateTime.parse(json["endDateTime"]),
      maxVolunteers: json["maxVolunteers"],
      status: json["status"],
      currentVolunteers: json["currentVolunteers"],
      applicationsCount: json["applicationsCount"],
    );
  }
}