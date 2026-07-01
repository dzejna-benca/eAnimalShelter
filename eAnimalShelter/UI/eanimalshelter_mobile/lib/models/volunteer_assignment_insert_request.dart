class VolunteerAssignmentInsertRequest {
  final int activityId;
  final String? applicationNote;

  VolunteerAssignmentInsertRequest({
    required this.activityId,
    this.applicationNote,
  });

  Map<String, dynamic> toJson() {
    return {
      "activityId": activityId,
      "applicationNote": applicationNote,
    };
  }
}