import 'animal.dart';
import 'user.dart';

class AdoptionRequest {
  int adoptionRequestId;

  int userId;
  int animalId;

  String? userName;
  String? animalName;

  DateTime requestDate;

  String housingType;
  String experienceWithPets;
  int householdMembers;

  String? additionalNotes;

  int status;

  String? adminComment;

  User? user;
  Animal? animal;

  AdoptionRequest({
    required this.adoptionRequestId,
    required this.userId,
    required this.animalId,
    this.userName,
    this.animalName,
    required this.requestDate,
    required this.housingType,
    required this.experienceWithPets,
    required this.householdMembers,
    this.additionalNotes,
    required this.status,
    this.adminComment,
    this.user,
    this.animal,
  });

  factory AdoptionRequest.fromJson(
      Map<String, dynamic> json) {
    return AdoptionRequest(
      adoptionRequestId:
          json["adoptionRequestId"],
      userId: json["userId"],
      animalId: json["animalId"],
      userName: json["userName"],
      animalName: json["animalName"],
      requestDate:
          DateTime.parse(json["requestDate"]),
      housingType:
          json["housingType"] ?? "",
      experienceWithPets:
          json["experienceWithPets"] ?? "",
      householdMembers:
          json["householdMembers"] ?? 0,
      additionalNotes:
          json["additionalNotes"],
      status: json["status"] ?? 0,
      adminComment:
          json["adminComment"],
      user: json["user"] != null
          ? User.fromJson(json["user"])
          : null,
      animal: json["animal"] != null
          ? Animal.fromJson(json["animal"])
          : null,
    );
  }
}