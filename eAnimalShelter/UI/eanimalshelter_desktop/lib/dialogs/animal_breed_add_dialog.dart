import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/animal_species.dart';
import '../providers/animal_breed_provider.dart';
import '../utils/message_helper.dart';

class AnimalBreedAddDialog extends StatefulWidget {
  final AnimalSpecies species;

  const AnimalBreedAddDialog({
    super.key,
    required this.species,
  });

  @override
  State<AnimalBreedAddDialog> createState() =>
      _AnimalBreedAddDialogState();
}

class _AnimalBreedAddDialogState
    extends State<AnimalBreedAddDialog> {
  final _formKey = GlobalKey<FormState>();

  final _breedController = TextEditingController();

  bool _loading = false;
  String? _breedError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Add breed (${widget.species.speciesName})",
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _breedController,
          decoration: InputDecoration(
            labelText: "Breed name",
            errorText: _breedError,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Breed name is required";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              _loading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: _loading ? null : _save,
          child: const Text("Save"),
        ),
      ],
    );
  }

  Future<void> _save() async {
  setState(() {
    _breedError = null;
    _loading = true;
  });

  if (!_formKey.currentState!.validate()) {
    setState(() {
      _loading = false;
    });
    return;
  }

  try {
    await context.read<AnimalBreedProvider>().insert({
      "breedName": _breedController.text.trim(),
      "speciesId": widget.species.speciesId,
    });

    if (!mounted) return;

    MessageHelper.showSuccess(
      context,
      "Breed successfully added.",
    );

    Navigator.pop(context, true);
  } catch (e) {
  if (!mounted) return;

  setState(() {
    _breedError = e.toString().replaceFirst("Exception: ", "");
    _loading = false;
  });
}
}
}