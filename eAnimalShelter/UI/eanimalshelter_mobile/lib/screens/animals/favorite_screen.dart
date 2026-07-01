import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/favorite.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/favorite_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      FavoritesScreenState();
}

class FavoritesScreenState
    extends State<FavoritesScreen> {

  List<Favorite> _favorites = [];
  List<Favorite> _filtered = [];

  bool _loading = true;

  String _search = "";

  String _selectedCategory = "All";

  final categories = const [
    "All",
    "Dog",
    "Cat",
    "Bird",
    "Rabbit",
  ];
  Future<void> refresh() async {
  await _loadFavorites();
}

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.watch<FavoriteProvider>();

    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final provider =
          context.read<FavoriteProvider>();

      final favorites =
          await provider.getFavorites();

      if (!mounted) return;

      setState(() {
        _favorites = favorites;
        _filtered = favorites;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _applyFilters() {

    List<Favorite> list = _favorites;

    if (_search.isNotEmpty) {
      list = list.where((e) {

        return e.animal.name
            .toLowerCase()
            .contains(
                _search.toLowerCase());

      }).toList();
    }

    if (_selectedCategory != "All") {

      list = list.where((e) {

        return (e.animal.speciesName ?? "")
                .toLowerCase() ==
            _selectedCategory.toLowerCase();

      }).toList();
    }

    setState(() {
      _filtered = list;
    });
  }

  Future<void> _removeFavorite(
      Favorite favorite) async {

    final provider =
        context.read<FavoriteProvider>();

    await provider.delete(
      favorite.favoriteId,
    );

    if (!mounted) return;

    setState(() {

      _favorites.removeWhere(
        (e) =>
            e.favoriteId ==
            favorite.favoriteId,
      );

      _applyFilters();
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "${favorite.animal.name} removed from favorites",
        ),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites"),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 16, 16, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            "Search favorites...",
                        prefixIcon:
                            const Icon(Icons.search),
                        filled: true,
                        fillColor:
                            Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  30),
                        ),
                      ),
                      onChanged: (value) {
                        _search = value;
                        _applyFilters();
                      },
                    ),
                  ),

                  SizedBox(
                    height: 55,
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 16),
                      scrollDirection:
                          Axis.horizontal,
                      itemCount:
                          categories.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(width: 8),
                      itemBuilder:
                          (context, index) {
                        final category =
                            categories[index];

                        return ChoiceChip(
                          label: Text(category),
                          selected:
                              category ==
                                  _selectedCategory,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory =
                                  category;
                            });

                            _applyFilters();
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: _filtered.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 120),
                              Icon(
                                Icons.favorite_border,
                                size: 90,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  "No favorite animals yet.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  "Tap the heart icon on an animal to add it here.",
                                  textAlign:
                                      TextAlign.center,
                                ),
                              )
                            ],
                          )
                        : GridView.builder(
                            padding:
                                const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 280,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.60,
                            ),
                            itemCount:
                                _filtered.length,
                            itemBuilder:
                                (context, index) {
                              final favorite =
                                  _filtered[index];

                              return FavoriteCard(
                                favorite: favorite,
                                onRemove: () =>
                                    _removeFavorite(
                                        favorite),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
