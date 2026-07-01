import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../screens/animals/animals_details_screen.dart';
import '../utils/app_config.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;

  final bool isFavorite;

  final VoidCallback onFavoritePressed;

  const AnimalCard({
    super.key,
    required this.animal,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  String getGender() {
    return animal.gender == 1
        ? "Male"
        : "Female";
  }

  String getImageUrl() {
    if (animal.images.isEmpty) {
      return "";
    }

    return "${AppConfig.baseUrl}${animal.images.first.imagePath}";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;

        final imageHeight = cardHeight * 0.40;
        final titleSize = cardHeight * 0.055;
        final textSize = cardHeight * 0.04;

        return Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [

                  animal.images.isNotEmpty
                      ? Image.network(
                          getImageUrl(),
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                                  _placeholder(),
                        )
                      : _placeholder(),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(30),
                      onTap: onFavoritePressed,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            Colors.white70,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        animal.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: TextStyle(
                          fontSize:
                              titleSize.clamp(
                            14,
                            20,
                          ),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        "${animal.speciesName ?? ""} • ${animal.breedName ?? ""}",
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: TextStyle(
                          fontSize:
                              textSize.clamp(
                            11,
                            14,
                          ),
                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        getGender(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AnimalDetailsScreen(
                                  animal: animal,
                                ),
                              ),
                            );
                          },
                          child: const Text("Details"),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 55,
        ),
      ),
    );
  }
}