import 'package:flutter/material.dart';
import '../models/animal_recommendation.dart';
import '../screens/animals/animals_details_screen.dart';
import '../utils/app_config.dart';

class RecommendationCard extends StatelessWidget {
  final AnimalRecommendation recommendation;

  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final animal = recommendation.animal;

    String? imageUrl;

    if (animal.images.isNotEmpty) {
      imageUrl =
          "${AppConfig.baseUrl}${animal.images.first.imagePath}";
    }

    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnimalDetailsScreen(
                  animal: animal,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: imageUrl == null
                    ? Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),

              Padding(
                padding:
                    const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      recommendation.reason,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}