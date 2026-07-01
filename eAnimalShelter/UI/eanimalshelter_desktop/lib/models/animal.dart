import 'animal_image.dart';

class Animal {
  int animalId;
  String name;

  String? speciesName;
  String? breedName;

  int gender;
  int adoptionStatus;

  String? description;
  String? personalityDescription;
  String? healthStatus;
  bool isVaccinated;
  String? medicalNotes;

  int? speciesId;
  int? breedId;

  DateTime? birthDate;
  DateTime? arrivalDate;

  List<AnimalImage> images;

  Animal({
    required this.animalId,
    required this.name,
    this.speciesName,
    this.breedName,
    required this.gender,
    required this.adoptionStatus,
    required this.description,
    required this.personalityDescription,
    required this.healthStatus,
    this.medicalNotes,
    required this.isVaccinated,
    this.speciesId,
    this.breedId,
    this.birthDate,
    this.arrivalDate,
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
      gender: json["gender"] ?? 0,
      adoptionStatus:
          json["adoptionStatus"] ?? 0,
      description:
          json["description"],
      personalityDescription:
          json["personalityDescription"],
      healthStatus:
          json["healthStatus"],
      medicalNotes:
          json["medicalNotes"],
      isVaccinated:
          json["isVaccinated"] ?? false,
      speciesId: json["speciesId"],
      breedId: json["breedId"],

      birthDate: json["birthDate"] != null
          ? DateTime.parse(json["birthDate"])
          : null,

      arrivalDate: json["arrivalDate"] != null
          ? DateTime.parse(json["arrivalDate"])
          : null,
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