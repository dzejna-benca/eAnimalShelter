import 'animal.dart';

class Favorite {
  final int favoriteId;
  final Animal animal;
  final DateTime dateAdded;

  Favorite({
    required this.favoriteId,
    required this.animal,
    required this.dateAdded,
  });

  factory Favorite.fromJson(
      Map<String, dynamic> json) {
    return Favorite(
      favoriteId: json["favoriteId"],
      animal: Animal.fromJson(json["animal"]),
      dateAdded:
          DateTime.parse(json["dateAdded"]),
    );
  }
}