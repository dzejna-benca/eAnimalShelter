import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/animal.dart';
import '../../providers/animal_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/animal_card.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() =>
      _AnimalsScreenState();
}

class _AnimalsScreenState
    extends State<AnimalsScreen> {
  List<Animal> animals = [];
  List<Animal> filteredAnimals = [];

  bool isLoading = true;
  String? error;

  String searchText = "";
  String selectedCategory = "All";

  Set<int> _favoriteIds = {};

  bool _loadingFavorites = true;

  final List<String> categories = [
    "All",
    "Dog",
    "Cat",
    "Bird",
    "Rabbit",
  ];

  @override
  void initState() {
    super.initState();
    loadAnimals();
    _loadFavorites();
  }

  Future<void> loadAnimals() async {
    try {
      final provider =
          context.read<AnimalProvider>();

      final result =
          await provider.get(
        filter: {
          "page": 1,
          "pageSize": 100,
          "adoptionStatus": 0,
        },
      );

     setState(() {
      animals = result.items
          .where((x) => x.adoptionStatus == 0)
          .toList();

      filteredAnimals = animals;

      isLoading = false;
    });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  Future<void> _loadFavorites() async {
  final provider =
      context.read<FavoriteProvider>();

  final ids =
      await provider.getMyFavoriteIds();

  if (!mounted) return;

  setState(() {
    _favoriteIds = ids.toSet();
    _loadingFavorites = false;
  });
}

  void applyFilters() {
    List<Animal> result = animals;

    // SEARCH
    if (searchText.isNotEmpty) {
      result = result.where((animal) {
        return animal.name
            .toLowerCase()
            .contains(
              searchText.toLowerCase(),
            );
      }).toList();
    }

    // CATEGORY
    if (selectedCategory != "All") {
      result = result.where((animal) {
        return (animal.speciesName ?? "")
                .toLowerCase() ==
            selectedCategory.toLowerCase();
      }).toList();
    }

    setState(() {
      filteredAnimals = result;
    });
  }
  Future<void> _toggleFavorite(
    int animalId) async {
  final provider =
      context.read<FavoriteProvider>();

  final wasFavorite =
      _favoriteIds.contains(animalId);

  await provider.toggleFavorite(
      animalId);

  setState(() {
    if (wasFavorite) {
      _favoriteIds.remove(animalId);
    } else {
      _favoriteIds.add(animalId);
    }
  });

  if (!mounted) return;

  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(
        wasFavorite
            ? "Removed from favorites"
            : "Added to favorites",
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (isLoading || _loadingFavorites) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Animals",
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              8,
            ),
            child: TextField(
              decoration:
                  InputDecoration(
                hintText:
                    "Search animals...",
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                filled: true,
                fillColor:
                    Colors.grey.shade100,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),
              ),
              onChanged: (value) {
                searchText = value;
                applyFilters();
              },
            ),
          ),

          // CATEGORY FILTERS
          SizedBox(
            height: 55,
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              scrollDirection:
                  Axis.horizontal,
              itemBuilder:
                  (context, index) {
                final category =
                    categories[index];

                final selected =
                    category ==
                        selectedCategory;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory =
                          category;
                    });

                    applyFilters();
                  },
                );
              },
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(
                width: 8,
              ),
              itemCount:
                  categories.length,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child:
                  filteredAnimals.isEmpty
                      ? const Center(
                          child: Text(
                            "No animals found",
                          ),
                        )
                      : GridView.builder(
                        itemCount: filteredAnimals.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (_, index) {
                          final animal = filteredAnimals[index];

                          return AnimalCard(
                            animal: animal,
                            isFavorite: _favoriteIds.contains(
                              animal.animalId,
                            ),
                            onFavoritePressed: () =>
                                _toggleFavorite(animal.animalId),
                          );
                        },
                      )
                            )
                           ),
                          ],
                        ),
 
      );

  }
}