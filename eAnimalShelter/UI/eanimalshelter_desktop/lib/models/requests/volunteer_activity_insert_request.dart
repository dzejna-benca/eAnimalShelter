class VolunteerActivityInsertRequest {
  String title;
  String description;
  int locationId;

  DateTime startDateTime;
  DateTime endDateTime;

  int maxVolunteers;

  VolunteerActivityInsertRequest({
    required this.title,
    required this.description,
    required this.locationId,
    required this.startDateTime,
    required this.endDateTime,
    required this.maxVolunteers,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "locationId": locationId,
    "startDateTime":
        startDateTime.toIso8601String(),
    "endDateTime":
        endDateTime.toIso8601String(),
    "maxVolunteers": maxVolunteers,
  };
}