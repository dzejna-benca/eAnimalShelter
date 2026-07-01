import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/animal_species_provider.dart';
import '../utils/message_helper.dart';

class AnimalSpeciesAddDialog extends StatefulWidget {
  const AnimalSpeciesAddDialog({super.key});

  @override
  State<AnimalSpeciesAddDialog> createState() =>
      _AnimalSpeciesAddDialogState();
}

class _AnimalSpeciesAddDialogState
    extends State<AnimalSpeciesAddDialog> {
  final _formKey = GlobalKey<FormState>();

  final _speciesController = TextEditingController();

  bool _loading = false;
  String? _speciesError;

  @override
  void dispose() {
    _speciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Species"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _speciesController,
          decoration: InputDecoration(
            labelText: "Species name",
            errorText: _speciesError,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Species name is required";
            }

            if (value.trim().length < 2) {
              return "Minimum 2 characters.";
            }

            if (value.trim().length > 50) {
              return "Maximum 50 characters.";
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () => Navigator.pop(context),
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
      _speciesError = null;
      _loading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      await context
          .read<AnimalSpeciesProvider>()
          .insert({
        "speciesName":
            _speciesController.text.trim(),
      });

      if (!mounted) return;

      MessageHelper.showSuccess(
        context,
        "Species successfully added.",
      );

      Navigator.pop(context, true);
    } catch (e) {
  if (!mounted) return;

  final error = e.toString().replaceFirst("Exception: ", "");

  setState(() {
    _speciesError = error;
  });
} finally {
  if (mounted) {
    setState(() {
      _loading = false;
    });
  }
}
  }
  }
