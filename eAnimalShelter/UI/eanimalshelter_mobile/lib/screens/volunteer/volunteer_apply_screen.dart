import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/volunteer_activity.dart';
import '../../models/volunteer_assignment_insert_request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/volunteer_assignment_provider.dart';

class VolunteerApplyScreen extends StatefulWidget {
  final VolunteerActivity activity;

  const VolunteerApplyScreen({
    super.key,
    required this.activity,
  });

  @override
  State<VolunteerApplyScreen> createState() =>
      _VolunteerApplyScreenState();
}

class _VolunteerApplyScreenState
    extends State<VolunteerApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _noteController =
      TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  "Confirm Application",
                ),
                content: Text(
                  "Are you sure you want to apply for '${widget.activity.title}'?",
                ),
                actions: [
                  TextButton(
                    onPressed:
                        () => Navigator.pop(
                          context,
                          false,
                        ),
                    child: const Text(
                      "No",
                    ),
                  ),
                  FilledButton(
                    onPressed:
                        () => Navigator.pop(
                          context,
                          true,
                        ),
                    child: const Text(
                      "Yes",
                    ),
                  ),
                ],
              ),
        );

    if (confirmed != true) return;

    setState(() {
      _loading = true;
    });

    try {
      final provider =
          context.read<
            VolunteerAssignmentProvider
          >();

      await provider.apply(
        VolunteerAssignmentInsertRequest(
          activityId:
              widget.activity.activityId,
          applicationNote:
              _noteController.text.trim(),
        ),
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              title: const Text(
                "Application Submitted",
              ),
              content: Text(
                "You have successfully applied for '${widget.activity.title}'.",
              ),
              actions: [
                FilledButton(
                  onPressed:
                      () => Navigator.pop(
                        context,
                      ),
                  child: const Text(
                    "OK",
                  ),
                ),
              ],
            ),
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Volunteer Application",
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(
            16,
          ),
          children: [
            _buildReadOnlyField(
              "First Name",
              auth.firstName ?? "",
            ),

            const SizedBox(height: 16),

            _buildReadOnlyField(
              "Last Name",
              auth.lastName ?? "",
            ),

            const SizedBox(height: 16),

            _buildReadOnlyField(
              "Email",
              auth.email ?? "",
            ),

            const SizedBox(height: 16),

            _buildReadOnlyField(
              "Phone",
              auth.phoneNumber ?? "",
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller:
                  _noteController,
              maxLines: 5,
              decoration:
                  const InputDecoration(
                    labelText:
                        "Additional Note (optional)",
                    border:
                        OutlineInputBorder(),
                    alignLabelWithHint:
                        true,
                  ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _loading
                            ? null
                            : () => Navigator.pop(
                              context,
                            ),
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: FilledButton(
                    onPressed:
                        _loading
                            ? null
                            : _apply,
                    child:
                        _loading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                            )
                            : const Text(
                              "Apply",
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value,
  ) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border:
            const OutlineInputBorder(),
      ),
    );
  }
}