class AnimalSpecies {
  int speciesId;
  String speciesName;

  AnimalSpecies({
    required this.speciesId,
    required this.speciesName,
  });

  factory AnimalSpecies.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnimalSpecies(
      speciesId: json["speciesId"],
      speciesName:
          json["speciesName"] ?? "",
    );
  }
}