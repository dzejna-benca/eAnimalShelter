import 'animal.dart';

class AdoptionRequest {
  int? adoptionRequestId;
  int? animalId;
  String? animalName;
  DateTime? requestDate;
  String? housingType;
  String? experienceWithPets;
  int? householdMembers;
  String? additionalNotes;
  String? status;
  String? adminComment;
  Animal? animal;

  AdoptionRequest({
    this.adoptionRequestId,
    this.animalId,
    this.animalName,
    this.requestDate,
    this.housingType,
    this.experienceWithPets,
    this.householdMembers,
    this.additionalNotes,
    this.status,
    this.adminComment,
    this.animal
  });

  factory AdoptionRequest.fromJson(
    Map<String, dynamic> json) {
  return AdoptionRequest(
    adoptionRequestId:
        json["adoptionRequestId"],
    animalId: json["animalId"],
    animalName: json["animalName"],
    requestDate: json["requestDate"] != null
        ? DateTime.parse(
            json["requestDate"])
        : null,
    housingType: json["housingType"],
    experienceWithPets:
        json["experienceWithPets"],
    householdMembers:
        json["householdMembers"],
    additionalNotes:
        json["additionalNotes"],
    status: _statusToText(
      json["status"],
    ),
    adminComment:
        json["adminComment"],
    animal: json["animal"] != null
    ? Animal.fromJson(json["animal"])
    : null,
  );
}

static String _statusToText(
    dynamic value) {
  switch (value) {
    case 0:
      return "Pending";
    case 1:
      return "Approved";
    case 2:
      return "Rejected";
    case 3:
      return "Cancelled";
    default:
      return "Unknown";
  }
}
}