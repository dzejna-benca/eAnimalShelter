class Location {
  int? locationId;
  String? name;

  Location({
    this.locationId,
    this.name,
  });

  factory Location.fromJson(
    Map<String, dynamic> json,
  ) {
    return Location(
      locationId: json["locationId"],
      name: json["name"],
    );
  }
}