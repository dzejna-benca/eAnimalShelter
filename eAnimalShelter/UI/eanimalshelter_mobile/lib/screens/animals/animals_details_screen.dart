import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/animal.dart';
import '../../utils/app_config.dart';
import 'adoption_request_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/animal_view_history_provider.dart';
import '../../providers/favorite_provider.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final Animal animal;

  const AnimalDetailsScreen({
    super.key,
    required this.animal,
  });

  @override
  State<AnimalDetailsScreen> createState() =>
      _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState
    extends State<AnimalDetailsScreen> {
  final PageController _pageController =
      PageController();
  bool _isFavorite = false;
  bool _loadingFavorite = true;
  bool _viewSaved = false;

Future<void> _saveView() async {
  if (_viewSaved) return;

  _viewSaved = true;

  try {
    await context
        .read<AnimalViewHistoryProvider>()
        .addView(widget.animal.animalId);
  } catch (_) {}
}
  
  @override
void initState() {
  super.initState();
  _loadFavorite();
  WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AnimalViewHistoryProvider>()
          .recordView(widget.animal.animalId);
    });
}
  String getGender() {
    return widget.animal.gender == 1
        ? "Male"
        : "Female";
  }

  String getAge() {
    final now = DateTime.now();

    int years =
        now.year - widget.animal.birthDate.year;

    if (years <= 0) {
      return "< 1 year";
    }

    return "$years years";
  }

  String getArrivalDate() {
    final date =
        widget.animal.arrivalDate;

    if (date == null) {
      return "-";
    }

    return "${date.day}.${date.month}.${date.year}";
  }
  Future<void> _loadFavorite() async {
  final provider = context.read<FavoriteProvider>();

  final ids = await provider.getMyFavoriteIds();

  if (!mounted) return;

  setState(() {
    _isFavorite = ids.contains(widget.animal.animalId);
    _loadingFavorite = false;
  });
}

Future<void> _toggleFavorite() async {
  final provider = context.read<FavoriteProvider>();

  await provider.toggleFavorite(widget.animal.animalId);

  if (!mounted) return;

  setState(() {
    _isFavorite = !_isFavorite;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        _isFavorite
            ? "Added to favorites"
            : "Removed from favorites",
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isTablet = width > 700;

    final imageHeight =
        isTablet ? 450.0 : width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pet Details",
        ),
         actions: [
          if (!_loadingFavorite)
            IconButton(
              icon: Icon(
                _isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              onPressed: _toggleFavorite,
            ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum:
            const EdgeInsets.all(16),
        child: SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    AdoptionRequestScreen(
                  animal: widget.animal,
                ),
              ),
            );
            },
            icon: const Icon(
              Icons.favorite,
            ),
            label: const Text(
              "Adopt Me",
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 950,
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal:
                    isTablet ? 32 : 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  // ===================
                  // IMAGE CAROUSEL
                  // ===================

                  ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        widget.animal.images.isEmpty
                            ? _placeholder()
                            : PageView.builder(
                                controller: _pageController,
                                itemCount: widget.animal.images.length,
                                itemBuilder: (context, index) {
                                  final image =
                                      "${AppConfig.baseUrl}${widget.animal.images[index].imagePath}";

                                  return Hero(
                                    tag: "animal_${widget.animal.animalId}",
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return _placeholder();
                                      },
                                    ),
                                  );
                                },
                              ),

                        Positioned(
                          top: 16,
                          right: 16,
                          child: Material(
                            color: Colors.white.withOpacity(.9),
                            shape: const CircleBorder(),
                            child: IconButton(
                              onPressed: _loadingFavorite
                                  ? null
                                  : _toggleFavorite,
                              icon: Icon(
                                _isFavorite
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
                ),

                  const SizedBox(
                    height: 12,
                  ),

                  if (widget.animal.images
                          .length >
                      1)
                    Center(
                      child:
                          SmoothPageIndicator(
                        controller:
                            _pageController,
                        count: widget
                            .animal
                            .images
                            .length,
                        effect:
                            WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================
                  // NAME
                  // ===================

                  Text(
                    widget.animal.name,
                    style:
                        const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    "${widget.animal.speciesName ?? "-"} • ${widget.animal.breedName ?? "-"}",
                    style: TextStyle(
                      fontSize: 17,
                      color:
                          Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================
                  // INFO CARDS
                  // ===================

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _InfoCard(
                        icon:
                            Icons.pets_outlined,
                        title: "Gender",
                        value:
                            getGender(),
                      ),
                      _InfoCard(
                        icon:
                            Icons.cake_outlined,
                        title: "Age",
                        value: getAge(),
                      ),
                      _InfoCard(
                        icon: Icons.health_and_safety,
                        title:
                            "Vaccinated",
                        value: widget
                                .animal
                                .isVaccinated
                            ? "Yes"
                            : "No",
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ===================
                  // ABOUT
                  // ===================

                  _SectionTitle(
                    title: "About",
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    widget
                        .animal
                        .description,
                    style:
                        const TextStyle(
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================
                  // PERSONALITY
                  // ===================

                  _SectionTitle(
                    title: "Personality",
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    widget
                                .animal
                                .personalityDescription
                                ?.trim()
                                .isNotEmpty ==
                            true
                        ? widget
                            .animal
                            .personalityDescription!
                        : "No personality information",
                    style:
                        const TextStyle(
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              const Icon(
                            Icons.favorite,
                          ),
                          title:
                              const Text(
                            "Health Status",
                          ),
                          subtitle: Text(
                            widget
                                        .animal
                                        .healthStatus
                                        ?.isNotEmpty ==
                                    true
                                ? widget
                                    .animal
                                    .healthStatus!
                                : "No information",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.calendar_today,
                          ),
                          title:
                              const Text(
                            "Arrival Date",
                          ),
                          subtitle: Text(
                            getArrivalDate(),
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.note_alt,
                          ),
                          title:
                              const Text(
                            "Medical Notes",
                          ),
                          subtitle: Text(
                            widget
                                        .animal
                                        .medicalNotes
                                        ?.isNotEmpty ==
                                    true
                                ? widget
                                    .animal
                                    .medicalNotes!
                                : "No medical notes",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 90,
        ),
      ),
    );
  }
}

class _SectionTitle
    extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .primaryContainer,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Column(
        children: [
          Icon(icon),

          const SizedBox(
            height: 8,
          ),

          Text(
            title,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,
            textAlign:
                TextAlign.center,
          ),
        ],
      ),
    );
  }
}