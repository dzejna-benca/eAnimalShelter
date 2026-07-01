import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/requests/user_password_change_request.dart';
import '../providers/profile_provider.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _currentController =
      TextEditingController();

  final _newController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  bool _loading = false;

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text("Confirm Password Change"),
        content: const Text(
          "Are you sure you want to change your password?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context, false),
            child:
                const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(
                    context, true),
            child: const Text(
              "Change Password",
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      setState(() {
        _loading = true;
      });

      await context
          .read<ProfileProvider>()
          .changePassword(
            UserPasswordChangeRequest(
              password:
                  _currentController.text,
              newPassword:
                  _newController.text,
              confirmNewPassword:
                  _confirmController.text,
            ),
          );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password changed successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceAll(
                  "Exception: ",
                  "",
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  InputDecoration _decoration(
    String label,
    bool visible,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          visible
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: toggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text("Change Password"),
      content: SizedBox(
        width: 430,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                TextFormField(
                  controller:
                      _currentController,
                  obscureText:
                      !_showCurrent,
                  decoration:
                      _decoration(
                    "Current Password",
                    _showCurrent,
                    () {
                      setState(() {
                        _showCurrent =
                            !_showCurrent;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Current password is required.";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height: 16),

                TextFormField(
                  controller:
                      _newController,
                  obscureText:
                      !_showNew,
                  decoration:
                      _decoration(
                    "New Password",
                    _showNew,
                    () {
                      setState(() {
                        _showNew =
                            !_showNew;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "New password is required.";
                    }

                    if (value.length <
                        6) {
                      return "Password must contain at least 6 characters.";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                    height: 16),

                TextFormField(
                  controller:
                      _confirmController,
                  obscureText:
                      !_showConfirm,
                  decoration:
                      _decoration(
                    "Confirm New Password",
                    _showConfirm,
                    () {
                      setState(() {
                        _showConfirm =
                            !_showConfirm;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Please confirm your password.";
                    }

                    if (value !=
                        _newController
                            .text) {
                      return "Passwords do not match.";
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () => Navigator.pop(
                    context,
                  ),
          child: const Text(
            "Cancel",
          ),
        ),
        FilledButton.icon(
          onPressed: _loading
              ? null
              : _changePassword,
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.lock_reset,
                ),
          label: const Text(
            "Change Password",
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}