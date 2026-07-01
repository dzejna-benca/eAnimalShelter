import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../utils/message_helper.dart';

class LocationAddDialog extends StatefulWidget {
  const LocationAddDialog({super.key});

  @override
  State<LocationAddDialog> createState() =>
      _LocationAddDialogState();
}

class _LocationAddDialogState
    extends State<LocationAddDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  bool _loading = false;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Location"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Location name",
            errorText: _nameError,
          ),
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return "Location name is required";
            }

            if (value.trim().length < 2) {
              return "Minimum 2 characters.";
            }

            if (value.trim().length > 100) {
              return "Maximum 100 characters.";
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
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _nameError = null;
    _loading = true;
  });

  try {
    await context.read<LocationProvider>().insert({
      "name": _nameController.text.trim(),
    });

    if (!mounted) return;

    MessageHelper.showSuccess(
      context,
      "Location successfully added.",
    );

    Navigator.pop(context, true);
  } catch (e) {
    if (!mounted) return;

    final error = e.toString().replaceFirst("Exception: ", "");

    setState(() {
      _nameError = error;
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
 