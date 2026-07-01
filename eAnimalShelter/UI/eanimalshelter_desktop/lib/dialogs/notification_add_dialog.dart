import 'package:flutter/material.dart';

import '../models/role.dart';
import '../models/user.dart';
import '../providers/notification_provider.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';
import '../utils/validators.dart';
import '../utils/message_helper.dart';

class NotificationAddDialog extends StatefulWidget {
  const NotificationAddDialog({
    super.key,
  });

  @override
  State<NotificationAddDialog> createState() =>
      _NotificationAddEditDialogState();
}

class _NotificationAddEditDialogState
    extends State<NotificationAddDialog> {
  final _formKey = GlobalKey<FormState>();

  late NotificationProvider _notificationProvider;
  late UserProvider _userProvider;
  late RoleProvider _roleProvider;

  List<User> users = [];
  List<Role> roles = [];

  User? selectedUser;
  Role? selectedRole;

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  int selectedType = 0;
  String recipientType = "user";

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _notificationProvider = NotificationProvider();
    _userProvider = UserProvider();
    _roleProvider = RoleProvider();

    loadData();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final userResult = await _userProvider.get();
      final roleResult = await _roleProvider.get();

      if (!mounted) return;

      setState(() {
        users = userResult.items;
        roles = roleResult.items;
      });
    } catch (e) {
      MessageHelper.showError(
        context,
        e.toString(),
      );
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (recipientType == "user" &&
        selectedUser == null) {
      MessageHelper.showError(
        context,
        "Please select a user.",
      );
      return;
    }

    if (recipientType != "user" &&
        selectedRole == null) {
      MessageHelper.showError(
        context,
        "Please select a role.",
      );
      return;
    }

    try {
      setState(() => _loading = true);

      await _notificationProvider.insert({
        "userId": recipientType == "user"
            ? selectedUser?.userId
            : null,
        "targetRoleId": recipientType != "user"
            ? selectedRole?.id
            : null,
        "title": titleController.text.trim(),
        "message": messageController.text.trim(),
        "type": selectedType,
      });

      if (!mounted) return;

      MessageHelper.showSuccess(
        context,
        "Notification sent successfully.",
      );

      Navigator.pop(context, true);
    } catch (e) {
      MessageHelper.showError(
        context,
        e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _selectVolunteerRole() {
    try {
      selectedRole = roles.firstWhere(
        (e) =>
            (e.name ?? "").toLowerCase() ==
            "volunteer",
      );
    } catch (_) {
      selectedRole = null;
    }
  }

  void _selectClientRole() {
    try {
      selectedRole = roles.firstWhere(
        (e) =>
            (e.name ?? "").toLowerCase() ==
            "client",
      );
    } catch (_) {
      selectedRole = null;
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 720,
          maxHeight: 800,
        ),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                color: Theme.of(context)
                    .colorScheme
                    .surface,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.notifications,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Create Notification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(
                      context,
                    ),
                    icon:
                        const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "Notification Details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors
                              .grey.shade600,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      TextFormField(
                        controller:
                            titleController,
                        decoration:
                            _inputDecoration(
                          "Title",
                        ),
                        validator:
                            AppValidators
                                .notificationTitle,
                      ),

                      const SizedBox(
                          height: 12),

                      TextFormField(
                        controller:
                            messageController,
                        maxLines: 5,
                        decoration:
                            _inputDecoration(
                          "Message",
                        ),
                        validator:
                            AppValidators
                                .notificationMessage,
                      ),

                      const SizedBox(
                          height: 24),

                      Text(
                        "Recipients",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors
                              .grey.shade600,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ChoiceChip(
                            label:
                                const Text(
                              "Single User",
                            ),
                            selected:
                                recipientType ==
                                    "user",
                            onSelected: (_) {
                              setState(() {
                                recipientType =
                                    "user";
                                selectedRole =
                                    null;
                              });
                            },
                          ),
                          ChoiceChip(
                            label:
                                const Text(
                              "All Volunteers",
                            ),
                            selected:
                                recipientType ==
                                    "volunteer",
                            onSelected: (_) {
                              setState(() {
                                recipientType =
                                    "volunteer";
                                _selectVolunteerRole();
                              });
                            },
                          ),
                          ChoiceChip(
                            label:
                                const Text(
                              "All Clients",
                            ),
                            selected:
                                recipientType ==
                                    "client",
                            onSelected: (_) {
                              setState(() {
                                recipientType =
                                    "client";
                                _selectClientRole();
                              });
                            },
                          ),
                        ],
                      ),

                      if (recipientType ==
                          "user") ...[
                        const SizedBox(
                            height: 16),

                        DropdownButtonFormField<
                            User>(
                          value: selectedUser,
                          decoration:
                              _inputDecoration(
                            "Select User",
                          ),
                          validator:
                              (value) {
                            if (recipientType ==
                                    "user" &&
                                value ==
                                    null) {
                              return "Please select a user.";
                            }
                            return null;
                          },
                          items: users
                              .map(
                                (u) =>
                                    DropdownMenuItem<
                                        User>(
                                  value: u,
                                  child: Text(
                                    "${u.firstName} ${u.lastName}",
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged:
                              (value) {
                            setState(() {
                              selectedUser =
                                  value;
                            });
                          },
                        ),
                      ],

                      const SizedBox(
                          height: 20),

                      DropdownButtonFormField<
                          int>(
                        value: selectedType,
                        decoration:
                            _inputDecoration(
                          "Notification Type",
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(
                                "Adoption"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                                "Volunteer"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                                "Donation"),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text(
                                "Announcement"),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child:
                                Text("System"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType =
                                value ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(
                  bottom:
                      Radius.circular(24),
                ),
                color: Theme.of(context)
                    .colorScheme
                    .surface,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(
                        context,
                      ),
                      child:
                          const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _loading
                              ? null
                              : save,
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Text(
                              "Send Notification",
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
