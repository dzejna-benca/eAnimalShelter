import 'package:flutter/material.dart';

import '../models/favorite.dart';
import '../screens/animals/animals_details_screen.dart';
import '../utils/app_config.dart';

class FavoriteCard extends StatelessWidget {
  final Favorite favorite;

  final VoidCallback onRemove;

  const FavoriteCard({
    super.key,
    required this.favorite,
    required this.onRemove,
  });

  String getGender() {
    return favorite.animal.gender == 1
        ? "Male"
        : "Female";
  }

  String getImageUrl() {
    if (favorite.animal.images.isEmpty) {
      return "";
    }

    return "${AppConfig.baseUrl}${favorite.animal.images.first.imagePath}";
  }
  

  @override
  Widget build(BuildContext context) {
    final animal = favorite.animal;

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
                            BorderRadius.circular(
                                30),
                        onTap: onRemove,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Colors.white70,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
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

                      SizedBox(
                        height: 2,
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

                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        getGender(),
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),

                      SizedBox(
                        height: 2,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 36,
                        child:
                            ElevatedButton(
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
                          child:
                              const Text(
                            "Details",
                          ),
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