import 'volunteer_activity_insert_request.dart';

class VolunteerActivityUpdateRequest
    extends VolunteerActivityInsertRequest {
 

  VolunteerActivityUpdateRequest({
    required super.title,
    required super.description,
    required super.locationId,
    required super.startDateTime,
    required super.endDateTime,
    required super.maxVolunteers,
    
  });

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    
  };
}