class AnimalBreed {
  int breedId;
  String breedName;

  int speciesId;

  AnimalBreed({
    required this.breedId,
    required this.breedName,
    required this.speciesId,
  });

  factory AnimalBreed.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnimalBreed(
      breedId: json["breedId"],
      breedName:
          json["breedName"] ?? "",
      speciesId:
          json["speciesId"] ?? 0,
    );
  }
}