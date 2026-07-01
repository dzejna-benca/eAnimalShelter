import 'animal_image.dart';

class Animal {
  final int animalId;
  final String name;
  final String? speciesName;
  final String? breedName;
  final int gender;
  final DateTime birthDate;
  final String description;
  final int adoptionStatus;
  final String? personalityDescription;
  final String? healthStatus;
  final bool isVaccinated;
  final String? medicalNotes;
  final DateTime? arrivalDate;

  final List<AnimalImage> images;

 Animal({
  required this.animalId,
  required this.name,
  this.speciesName,
  this.breedName,
  required this.gender,
  required this.birthDate,
  required this.description,
  this.personalityDescription,
  this.healthStatus,
  required this.isVaccinated,
  this.medicalNotes,
  this.arrivalDate,
  required this.adoptionStatus,
  required this.images,
});

  factory Animal.fromJson(
    Map<String, dynamic> json,
  ) {
    return Animal(
  animalId: json["animalId"],
  name: json["name"] ?? "",
  speciesName: json["speciesName"],
  breedName: json["breedName"],
  gender: json["gender"],
  birthDate: DateTime.parse(
    json["birthDate"],
  ),
  description:
      json["description"] ?? "",

  personalityDescription:
      json["personalityDescription"] ?? "",

  healthStatus:
      json["healthStatus"] ?? "",

  isVaccinated:
      json["isVaccinated"] ?? false,

  medicalNotes:
      json["medicalNotes"] ?? "",

  arrivalDate:
      json["arrivalDate"] != null
          ? DateTime.parse(
              json["arrivalDate"],
            )
          : null,

  adoptionStatus:
      json["adoptionStatus"],

  images:
      (json["images"] as List?)
              ?.map(
                (e) =>
                    AnimalImage.fromJson(e),
              )
              .toList() ??
          [],
);
}
}