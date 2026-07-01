import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/animal_add_edit_dialog.dart';
import '../models/animal.dart';
import '../models/animal_species.dart';
import '../models/search_result.dart';
import '../providers/animal_provider.dart';
import '../providers/animal_species_provider.dart';
import '../widgets/master_screen.dart';
import 'animal_details_screen.dart';
import '../utils/message_helper.dart';
import '../utils/dialog_helper.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  late AnimalProvider _animalProvider;
  late AnimalSpeciesProvider _speciesProvider;

  SearchResult<Animal>? result;
  List<AnimalSpecies> species = [];

  final TextEditingController _searchController = TextEditingController();

  int? selectedSpeciesId;
  int? selectedStatus;

  String? sortBy;

  int currentPage = 1;
  int pageSize = 10;

  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animalProvider = context.read<AnimalProvider>();
    _speciesProvider = context.read<AnimalSpeciesProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);

    try {
      var animals = await _animalProvider.get(filter: {
        "page": currentPage,
        "pageSize": pageSize,
        "includeTotalCount": true,
        "name": _searchController.text,
        "speciesId": selectedSpeciesId,
        "adoptionStatus": selectedStatus,
        "sortBy": sortBy,
      });

      var speciesResult = await _speciesProvider.get();

      setState(() {
        result = animals;
        species = speciesResult.items;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      MessageHelper.showError(
      context,
      e.toString(),
    );
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
  Widget buildStatusChip(int status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case 0:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = "Available";
        break;

      case 1:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = "Pending";
        break;

      case 2:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = "Adopted";
        break;

      case 3:
        backgroundColor = Colors.grey.shade300;
        textColor = Colors.grey.shade800;
        text = "Archived";
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.black87;
        text = "-";
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  Widget buildVaccinatedChip(bool vaccinated) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: vaccinated
              ? Colors.green.shade100
              : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          vaccinated
              ? "Vaccinated"
              : "Not Vaccinated",
          style: TextStyle(
            color: vaccinated
                ? Colors.green.shade800
                : Colors.red.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  @override
  Widget build(BuildContext context) {
    int totalPages =
    ((result?.totalCount ?? 0) / pageSize).ceil();
    return MasterScreen(
      title: "Animals",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // FILTERS
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              labelText: "Search animal",
                              prefixIcon: Icon(Icons.search),
                            ),
                            onSubmitted: (_) {
                            currentPage = 1;
                            _loadData();
                          },
                          ),
                        ),

                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<int?>(
                            value: selectedSpeciesId,
                            decoration: const InputDecoration(
                              labelText: "Species",
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text("All"),
                              ),
                              ...species.map(
                                (e) => DropdownMenuItem(
                                  value: e.speciesId,
                                  child: Text(e.speciesName),
                                ),
                              )
                            ],
                            onChanged: (value) {
                              setState((){ selectedSpeciesId = value;
                              currentPage = 1;
                            });
                            _loadData();
                            },
                          ),
                        ),

                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<int?>(
                            value: selectedStatus,
                            decoration: const InputDecoration(
                              labelText: "Status",
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text("All")),
                              DropdownMenuItem(value: 0, child: Text("Available")),
                              DropdownMenuItem(value: 1, child: Text("Pending")),
                              DropdownMenuItem(value: 2, child: Text("Adopted")),
                            ],
                            onChanged: (value) {
                              setState(() { selectedStatus = value;
                              currentPage = 1;
                            });
                            _loadData();
                            },
                          ),
                        ),

                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<String>(
                            value: sortBy,
                            decoration: const InputDecoration(
                              labelText: "Sort By",
                            ),
                            items: const [
                              DropdownMenuItem(value: "name_asc", child: Text("Name A-Z")),
                              DropdownMenuItem(value: "name_desc", child: Text("Name Z-A")),
                              DropdownMenuItem(value: "arrival_desc", child: Text("Newest Arrival")),
                              DropdownMenuItem(value: "arrival_asc", child: Text("Oldest Arrival")),
                            ],
                            onChanged: (value) {
                              setState(() { sortBy = value;
                              currentPage = 1;
                              });
                              _loadData();
                            },
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            currentPage = 1;
                            _loadData();
                          },
                          icon: const Icon(Icons.search),
                          label: const Text("Search"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () async {
                            var refresh = await showDialog(
                            context: context,
                            builder: (context) =>
                                const AnimalAddEditDialog(),
                          );
                             if (!mounted) return;


                            if (refresh == true) {
                            MessageHelper.showSuccess(
                              this.context,
                              "Animal successfully added.",
                            );
                             
                            _loadData();
                          }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Animal"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TABLE
                Expanded(
                child: Card(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Image")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Species")),
                                DataColumn(label: Text("Breed")),
                                DataColumn(label: Text("Gender")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Vaccinated")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: result?.items.map((animal) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          animal.images.isNotEmpty
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    "http://localhost:5036${animal.images.first.imagePath}",
                                                  ),
                                                )
                                              : const CircleAvatar(child: Icon(Icons.pets)),
                                        ),
                                        DataCell(Text(animal.name)),
                                        DataCell(Text(animal.speciesName ?? "")),
                                        DataCell(Text(animal.breedName ?? "")),
                                        DataCell(Text(getGenderText(animal.gender))),
                                        DataCell(buildStatusChip(animal.adoptionStatus),),
                                        DataCell(buildVaccinatedChip(animal.isVaccinated,),),
                                        DataCell(
                                          PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              if (value == "details") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => AnimalDetailsScreen(
                                                      animalId: animal.animalId,
                                                    ),
                                                  ),
                                                );
                                              }
                                              
                                              if (value == "edit") {
                                              var refresh = await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AnimalAddEditDialog(
                                                  animal: animal,
                                                ),
                                              );
                                          
                                              if (refresh == true) {
                                              MessageHelper.showSuccess(
                                                context,
                                                "Animal information successfully updated.",
                                              );
                                              _loadData();
                                            }
                                              }
                                            if (value == "archive") {
                                                final confirmed =
                                                await DialogHelper.confirmAction(
                                              context,
                                              title: "Archive Animal",
                                              message:
                                                  "Are you sure you want to archive this animal?",
                                              confirmText: "Archive",
                                              isDestructive: true,
                                            );

                                             if (confirmed) {
                                              await _animalProvider.delete(
                                                animal.animalId,
                                              );
                                              
                                              MessageHelper.showSuccess(
                                                context,
                                                "Animal successfully archived.",
                                              );

                                              _loadData();
                                            }
                                            }
                                            },
                                            itemBuilder: (context) => const [
                                              PopupMenuItem(value: "details", child: Text("View Details")),
                                              PopupMenuItem(value: "edit", child: Text("Edit")),
                                              PopupMenuItem(value: "archive", child: Text("Archive")),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

                const SizedBox(height: 15),

                // PAGING
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () {
                              currentPage--;
                              _loadData();
                            }
                          : null,
                      child: const Text("Previous"),
                    ),

                    const SizedBox(width: 15),

                    Text(
                      "Page $currentPage of $totalPages",
                    ),

                    const SizedBox(width: 15),

                    ElevatedButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              currentPage++;
                              _loadData();
                            }
                          : null,
                      child: const Text("Next"),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

