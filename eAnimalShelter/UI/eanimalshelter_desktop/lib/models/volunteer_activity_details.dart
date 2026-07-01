import 'volunteer_assignment.dart';

class VolunteerActivityDetails {
  int? activityId;

  String? title;
  String? description;

  String? locationName;

  DateTime? startDateTime;
  DateTime? endDateTime;

  int? maxVolunteers;

  int? status;

  String? createdByUserName;

  List<VolunteerAssignment> assignments;

  VolunteerActivityDetails({
    this.activityId,
    this.title,
    this.description,
    this.locationName,
    this.startDateTime,
    this.endDateTime,
    this.maxVolunteers,
    this.status,
    this.createdByUserName,
    this.assignments = const [],
  });

  factory VolunteerActivityDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return VolunteerActivityDetails(
      activityId: json["activityId"],
      title: json["title"],
      description: json["description"],
      locationName: json["locationName"],
      startDateTime:
          json["startDateTime"] != null
              ? DateTime.parse(
                  json["startDateTime"])
              : null,
      endDateTime:
          json["endDateTime"] != null
              ? DateTime.parse(
                  json["endDateTime"])
              : null,
      maxVolunteers: json["maxVolunteers"],
      status: json["status"],
      createdByUserName:
          json["createdByUserName"],
      assignments: (json["assignments"] as List<dynamic>?)
    ?.map((x) => VolunteerAssignment.fromJson(x))
    .toList() ??
    [],
    
    );
    
  }
}