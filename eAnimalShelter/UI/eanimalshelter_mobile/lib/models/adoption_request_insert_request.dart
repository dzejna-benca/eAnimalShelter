class AdoptionRequestInsertRequest {
  int animalId;
  String housingType;
  String experienceWithPets;
  int householdMembers;
  String? additionalNotes;

  AdoptionRequestInsertRequest({
    required this.animalId,
    required this.housingType,
    required this.experienceWithPets,
    required this.householdMembers,
    this.additionalNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      "animalId": animalId,
      "housingType": housingType,
      "experienceWithPets": experienceWithPets,
      "householdMembers": householdMembers,
      "additionalNotes": additionalNotes,
    };
  }
}