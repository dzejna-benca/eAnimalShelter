import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/animal.dart';
import '../providers/animal_provider.dart';
import '../utils/app_config.dart';
import '../widgets/master_screen.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final int animalId;

  const AnimalDetailsScreen({
    super.key,
    required this.animalId,
  });

  @override
  State<AnimalDetailsScreen> createState() =>
      _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState
    extends State<AnimalDetailsScreen> {

  late AnimalProvider _animalProvider;

  Animal? animal;

  bool loading = true;

  int currentImage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animalProvider =
        context.read<AnimalProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var data =
          await _animalProvider.getById(
        widget.animalId,
      );

      setState(() {
        animal = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  String getGenderText(int gender) {
    switch (gender) {
      case 1:
        return "Male";
      case 2:
        return "Female";
      default:
        return "-";
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Available";
      case 1:
        return "Pending";
      case 2:
        return "Adopted";
      case 3:
        return "Archived";
      default:
        return "-";
    }
  }

  Widget _infoTile(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(value.isEmpty ? "-" : value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Animal Details",
      showBackButton: true,
      child: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : animal == null
              ? const Center(
                  child:
                      Text("Animal not found"),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [

                      /// IMAGE SLIDER

                      /// IMAGE SLIDER

Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [

        /// MAIN IMAGE

        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          clipBehavior: Clip.antiAlias,
          child: animal!.images.isEmpty
              ? const Center(
                  child: Icon(
                    Icons.pets,
                    size: 100,
                  ),
                )
              : Image.network(
                   "${AppConfig.baseUrl}${animal!.images[currentImage].imagePath}",
                  fit: BoxFit.contain,
                ),
        ),

        const SizedBox(height: 20),

        /// THUMBNAILS

        if (animal!.images.length > 1)
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection:
                  Axis.horizontal,
              itemCount:
                  animal!.images.length,
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(
                        width: 10,
                      ),
              itemBuilder:
                  (context, index) {
                bool selected =
                    currentImage ==
                        index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentImage =
                          index;
                    });
                  },
                  child: Container(
                    width: 120,
                    decoration:
                        BoxDecoration(
                      border: Border.all(
                        color: selected
                            ? Colors.teal
                            : Colors
                                .grey
                                .shade300,
                        width:
                            selected
                                ? 3
                                : 1,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                    clipBehavior:
                        Clip.antiAlias,
                    child:
                        Image.network(
                       "${AppConfig.baseUrl}${animal!.images[index].imagePath}",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    ),
  ),
),

const SizedBox(height: 20),

Card(
  child: Padding(
    padding:
        const EdgeInsets.all(20),
    child: Column(
      children: [
        Text(
          animal!.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          animal!.breedName ?? "",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),

_infoTile(
  "Species",
  animal!.speciesName ?? "",
),

const SizedBox(height: 10),

_infoTile(
  "Breed",
  animal!.breedName ?? "",
),

const SizedBox(height: 10),

_infoTile(
  "Gender",
  getGenderText(
    animal!.gender,
  ),
),

const SizedBox(height: 10),

_infoTile(
  "Status",
  getStatusText(
    animal!.adoptionStatus,
  ),
),

const SizedBox(height: 10),

_infoTile(
  "Vaccinated",
  animal!.isVaccinated
      ? "Yes"
      : "No",
),

const SizedBox(height: 20),

Row(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Expanded(
      child: _section(
        "Description",
        animal!.description ?? "",
      ),
    ),

    const SizedBox(width: 15),

    Expanded(
      child: _section(
        "Personality",
        animal!
                .personalityDescription ??
            "",
      ),
    ),
  ],
),

const SizedBox(height: 15),

Row(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Expanded(
      child: _section(
        "Health Status",
        animal!.healthStatus ?? "",
      ),
    ),

    const SizedBox(width: 15),

    Expanded(
      child: _section(
        "Medical Notes",
        animal!.medicalNotes ?? "",
      ),
      ),
       ],
        ),

               ], // children Column
                  ), 
                ), 
    );
  } // build
} // class




