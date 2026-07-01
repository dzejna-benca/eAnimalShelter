class Dashboard {
  int totalAnimals;
  int approvedAdoptions;
  int totalVolunteers;
  double totalDonations;
  Map<String, dynamic> animalsBySpecies;
  Map<String, dynamic> adoptedAnimalsBySpecies;

  Dashboard({
    required this.totalAnimals,
    required this.approvedAdoptions,
    required this.totalVolunteers,
    required this.totalDonations,
    required this.animalsBySpecies,
    required this.adoptedAnimalsBySpecies
  });

  factory Dashboard.fromJson(
    Map<String, dynamic> json,
  ) {
    return Dashboard(
      totalAnimals:
          json["totalAnimals"] ?? 0,
      approvedAdoptions:
          json["approvedAdoptions"] ?? 0,
      totalVolunteers:
          json["totalVolunteers"] ?? 0,
      totalDonations:
          (json["totalDonations"] ?? 0)
              .toDouble(),
      animalsBySpecies:
        Map<String, dynamic>.from
        (json["animalsBySpecies"] ?? {}),
      adoptedAnimalsBySpecies:
        Map<String, dynamic>.from
        (json["adoptedAnimalsBySpecies"] ?? {}),
    );
  }
}