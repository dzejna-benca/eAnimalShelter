import 'animal.dart';

class AnimalRecommendation {
  final Animal animal;
  final double score;
  final String reason;

  AnimalRecommendation({
    required this.animal,
    required this.score,
    required this.reason,
  });

  factory AnimalRecommendation.fromJson(
      Map<String, dynamic> json) {
    return AnimalRecommendation(
      animal: Animal.fromJson(json["animal"]),
      score: (json["score"] as num).toDouble(),
      reason: json["reason"] ?? "",
    );
  }
}