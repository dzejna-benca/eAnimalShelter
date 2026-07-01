import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/animal.dart';
import '../models/animal_breed.dart';
import '../models/animal_species.dart';
import '../models/requests/animal_insert_request.dart';
import '../providers/animal_provider.dart';
import '../providers/animal_species_provider.dart';
import '../providers/animal_breed_provider.dart';
import '../providers/animal_image_provider.dart';
import '../utils/validators.dart';
import '../utils/message_helper.dart';
import 'animal_breed_add_dialog.dart';
import 'animal_species_add_dialog.dart';

class AnimalAddEditDialog extends StatefulWidget {
  final Animal? animal;

  const AnimalAddEditDialog({super.key, this.animal});

  @override
  State<AnimalAddEditDialog> createState() => _AnimalAddEditDialogState();
}

class _AnimalAddEditDialogState extends State<AnimalAddEditDialog> {
  late final AnimalProvider _animalProvider;
  late final AnimalSpeciesProvider _speciesProvider;
  late final AnimalBreedProvider _breedProvider;
  late final AnimalImageProvider _imageProvider;

  final _formKey = GlobalKey<FormState>();

  List<AnimalSpecies> species = [];
  List<AnimalBreed> breeds = [];

  int? selectedSpeciesId;
  int? selectedBreedId;
  AnimalSpecies? get selectedSpecies {
  if (selectedSpeciesId == null) return null;

  try {
    return species.firstWhere(
      (e) => e.speciesId == selectedSpeciesId,
    );
  } catch (_) {
    return null;
  }
}

  int gender = 1;
  int adoptionStatus = 0;
  bool isVaccinated = false;

  DateTime? birthDate;
  DateTime? arrivalDate;

  bool loading = true;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personalityController = TextEditingController();
  final _healthController = TextEditingController();
  final _medicalController = TextEditingController();

  List<File> selectedImages = [];

  bool get isEdit => widget.animal != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    _animalProvider = context.read<AnimalProvider>();
    _speciesProvider = context.read<AnimalSpeciesProvider>();
    _breedProvider = context.read<AnimalBreedProvider>();
    _imageProvider = context.read<AnimalImageProvider>();

    await _load();
  }

  Future<void> _load() async {
  final s = await _speciesProvider.get();

  if (!mounted) return;

  species = s.items;

  if (isEdit) {
    final a = widget.animal!;

    _nameController.text = a.name;
    _descriptionController.text = a.description ?? "";
    _personalityController.text = a.personalityDescription ?? "";
    _healthController.text = a.healthStatus ?? "";
    _medicalController.text = a.medicalNotes ?? "";

    selectedSpeciesId = a.speciesId;

    await _loadBreeds(selectedSpeciesId!);

    selectedBreedId = a.breedId;

    gender = a.gender;
    adoptionStatus = a.adoptionStatus;
    isVaccinated = a.isVaccinated;

    birthDate = a.birthDate;
    arrivalDate = a.arrivalDate;
  }

  if (!mounted) return;

  setState(() {
    loading = false;
  });
}
  Future<void> _loadBreeds(int speciesId) async {
  final result = await _breedProvider.get(
    filter: {
      "speciesId": speciesId,
    },
  );

  if (!mounted) return;

  setState(() {
    breeds = result.items;
  });
}

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    final images =
        await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages =
            images.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => birthDate = picked);
    }
  }

  Future<void> _selectArrivalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: arrivalDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => arrivalDate = picked);
    }
  }
  Future<void> _loadSpecies() async {
  final result = await _speciesProvider.get();

  species = result.items;
}

  Future<void> _save() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final request = AnimalInsertRequest(
    name: _nameController.text,
    speciesId: selectedSpeciesId!,
    breedId: selectedBreedId!,
    gender: gender,
    birthDate: birthDate!,
    description: _descriptionController.text,
    personalityDescription: _personalityController.text,
    healthStatus: _healthController.text,
    isVaccinated: isVaccinated,
    medicalNotes: _medicalController.text,
    arrivalDate: arrivalDate,
    adoptionStatus: adoptionStatus,
  );

  try {
    int id;

    if (isEdit) {
      id = widget.animal!.animalId;

      await _animalProvider.update(
        id,
        request.toJson(),
      );
    } else {
      final res =
          await _animalProvider.insert(
        request.toJson(),
      );

      id = res.animalId;
    }

    await Future.wait(
      selectedImages.map(
        (image) => _imageProvider.uploadImage(
          id,
          image,
        ),
      ),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  } catch (e) {
    if (!mounted) return;

    MessageHelper.showError(
      context,
      e.toString(),
    );
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _healthController.dispose();
    _medicalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 1000,
        height: 700,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT SIDE
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? "Edit Animal" : "Add Animal",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                ),
                                validator: AppValidators.animalName,
                              ),

                              const SizedBox(height: 10),

                             Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: selectedSpeciesId,
                                    validator: (value) {
                                      if (value == null) {
                                        return "Species is required";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Species",
                                    ),
                                    items: species
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.speciesId,
                                            child: Text(e.speciesName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedSpeciesId = value;
                                        selectedBreedId = null;
                                      });

                                      if (value != null) {
                                        await _loadBreeds(value);
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10),

                                IconButton(
                                  tooltip: "Add species",
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    final refresh = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => const AnimalSpeciesAddDialog(),
                                    );

                                    if (refresh == true) {
                                      await _loadSpecies();

                                      // automatski selektuj posljednje dodanu species
                                      selectedSpeciesId = species.last.speciesId;

                                      // učitaj breedove za novu species (bit će prazni)
                                      await _loadBreeds(selectedSpeciesId!);

                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),

                              const SizedBox(height: 10),

                              Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: selectedBreedId,
                                    validator: (value) {
                                      if (value == null) {
                                        return "Breed is required";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Breed",
                                    ),
                                    items: breeds.map((e) {
                                      return DropdownMenuItem(
                                        value: e.breedId,
                                        child: Text(e.breedName),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBreedId = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  tooltip: "Add breed",
                                  icon: const Icon(Icons.add),
                                  onPressed: selectedSpecies == null
                                      ? null
                                      : () async {
                                          final refresh = await showDialog<bool>(
                                            context: context,
                                            builder: (_) => AnimalBreedAddDialog(
                                              species: selectedSpecies!,
                                            ),
                                          );

                                          if (refresh == true) {
                                            await _loadBreeds(selectedSpecies!.speciesId);
                                          }
                                        },
                                ),
                              ],
                            ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: FormField<DateTime>(
                                      validator: (_) {
                                        if (birthDate == null) {
                                          return "Birth date is required.";
                                        }

                                        if (birthDate!.isAfter(DateTime.now())) {
                                          return "Birth date must be earlier than today.";
                                        }

                                        return null;
                                      },
                                      builder: (field) {
                                        return InkWell(
                                          onTap: () async {
                                            await _selectBirthDate();
                                            field.didChange(birthDate);
                                          },
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: "Birth Date",
                                              border: const OutlineInputBorder(),
                                              errorText: field.errorText,
                                            ),
                                            child: Text(
                                              birthDate == null
                                                  ? "Select"
                                                  : "${birthDate!.day}.${birthDate!.month}.${birthDate!.year}",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: FormField<DateTime>(
                                      validator: (_) {
                                        if (arrivalDate == null) {
                                          return null;
                                        }

                                        if (arrivalDate!.isAfter(DateTime.now())) {
                                          return "Arrival date cannot be in the future.";
                                        }

                                        if (birthDate != null &&
                                            arrivalDate!.isBefore(birthDate!)) {
                                          return "Arrival date cannot be earlier than birth date.";
                                        }

                                        return null;
                                      },
                                      builder: (field) {
                                        return InkWell(
                                          onTap: () async {
                                            await _selectArrivalDate();
                                            field.didChange(arrivalDate);
                                          },
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: "Arrival Date",
                                              border: const OutlineInputBorder(),
                                              errorText: field.errorText,
                                            ),
                                            child: Text(
                                              arrivalDate == null
                                                  ? "Select"
                                                  : "${arrivalDate!.day}.${arrivalDate!.month}.${arrivalDate!.year}",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: gender,
                                      items: const [
                                        DropdownMenuItem(
                                            value: 1, child: Text("Male")),
                                        DropdownMenuItem(
                                            value: 2, child: Text("Female")),
                                      ],
                                      onChanged: (v) =>
                                          setState(() => gender = v!),
                                      decoration: const InputDecoration(
                                          labelText: "Gender"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SwitchListTile(
                                      title: const Text("Vaccinated"),
                                      value: isVaccinated,
                                      onChanged: (v) =>
                                          setState(() => isVaccinated = v),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                  ),
                                  validator: AppValidators.animalDescription,
                                ),

                              TextFormField(
                                controller: _personalityController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: "Personality",
                                ),
                                validator: AppValidators.personality,
                              ),

                              TextFormField(
                                controller: _healthController,
                                decoration: const InputDecoration(
                                  labelText: "Health Status",
                                ),
                                validator: AppValidators.healthStatus,
                              ),

                              TextFormField(
                                controller: _medicalController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    labelText: "Medical Notes"),
                                    validator: AppValidators.medicalNotes,
                              ),

                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: _save,
                                    child: Text(
                                        isEdit ? "Update" : "Create"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      /// RIGHT SIDE
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Animal Pictures",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(
                                  Icons.photo_library,
                                ),
                                label: const Text(
                                  "Select Images",
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// NEW IMAGES

                            if (selectedImages.isNotEmpty)
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children:
                                        selectedImages.map(
                                      (image) {
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12,
                                              ),
                                              child: Image.file(
                                                image,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),

                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImages
                                                        .remove(
                                                      image,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        Colors.red,
                                                    shape:
                                                        BoxShape.circle,
                                                  ),
                                                  child:
                                                      const Icon(
                                                    Icons.close,
                                                    color:
                                                        Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              )

                            /// EXISTING IMAGES (EDIT)

                            else if (isEdit &&
                                widget
                                    .animal!
                                    .images
                                    .isNotEmpty)
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children:
                                        widget.animal!.images
                                            .map(
                                      (img) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            img.imageUrl,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              )

                            else
                              Expanded(
                                child: Center(
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Colors.grey.shade300,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}