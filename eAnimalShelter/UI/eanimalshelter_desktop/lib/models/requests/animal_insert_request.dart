class AnimalInsertRequest {
  String name;

  int speciesId;
  int breedId;

  int gender;

  DateTime birthDate;

  String description;
  String personalityDescription;
  String healthStatus;

  bool isVaccinated;

  String? medicalNotes;

  DateTime? arrivalDate;

  int adoptionStatus;

  AnimalInsertRequest({
    required this.name,
    required this.speciesId,
    required this.breedId,
    required this.gender,
    required this.birthDate,
    required this.description,
    required this.personalityDescription,
    required this.healthStatus,
    required this.isVaccinated,
    this.medicalNotes,
    this.arrivalDate,
    required this.adoptionStatus,
  });

  Map<String, dynamic> toJson() {
  return {
    "name": name,
    "speciesId": speciesId,
    "breedId": breedId,
    "gender": gender,

    "birthDate": birthDate.toUtc().toIso8601String(),
    "arrivalDate": arrivalDate?.toUtc().toIso8601String(),

    "description": description.isEmpty ? null : description,
    "personalityDescription": personalityDescription.isEmpty ? null : personalityDescription,
    "healthStatus": healthStatus.isEmpty ? null : healthStatus,

    "isVaccinated": isVaccinated,
    "medicalNotes": medicalNotes,

    "adoptionStatus": adoptionStatus,
  };
}
}