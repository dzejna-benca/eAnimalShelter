import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/change_password_dialog.dart';
import '../models/requests/user_update_request.dart';
import '../models/user.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final firstNameController =
      TextEditingController();

  final lastNameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final addressController =
      TextEditingController();

  User? user;

  bool loading = true;
  bool saving = false;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    try {
      final result = await context
          .read<ProfileProvider>()
          .getProfile();

      firstNameController.text =
          result.firstName ?? "";

      lastNameController.text =
          result.lastName ?? "";

      emailController.text =
          result.email ?? "";

      phoneController.text =
          result.phoneNumber ?? "";

      addressController.text =
          result.address ?? "";

      if (!mounted) return;

      setState(() {
        user = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

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
    }
  }
    Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Save Changes"),
        content: const Text(
          "Do you want to save changes to your profile?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      setState(() {
        saving = true;
      });

      final updated =
          await context
              .read<ProfileProvider>()
              .updateProfile(
                UserUpdateRequest(
                  firstName:
                      firstNameController.text.trim(),
                  lastName:
                      lastNameController.text.trim(),
                  email:
                      emailController.text.trim(),
                  phoneNumber:
                      phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                  address:
                      addressController.text.trim().isEmpty
                          ? null
                          : addressController.text.trim(),
                  isActive: user?.isActive ?? true,
                  roleId: user?.roleId ?? 0,
                ),
              );

      if (!mounted) return;

      setState(() {
        user = updated;
        editMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile updated successfully.",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceAll("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  InputDecoration decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            tooltip: editMode
                ? "Cancel editing"
                : "Edit profile",
            icon: Icon(
              editMode
                  ? Icons.close
                  : Icons.edit,
            ),
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 900,
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      Card(
                        elevation: 5,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  22),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  28),
                          child: Row(
                            children: [

                              CircleAvatar(
                                radius: 42,
                                child: Text(
                                  (user?.firstName
                                              ?.isNotEmpty ??
                                          false)
                                      ? user!
                                          .firstName![0]
                                          .toUpperCase()
                                      : "A",
                                  style:
                                      const TextStyle(
                                    fontSize: 30,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 24),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    Text(
                                      "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                                      style:
                                          const TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Text(
                                      user?.email ?? "",
                                    ),

                                    const SizedBox(
                                        height: 10),

                                    Chip(
                                      avatar:
                                          const Icon(
                                              Icons
                                                  .admin_panel_settings,
                                              size:
                                                  18),
                                      label: Text(
                                        user?.role ??
                                            "",
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              FilledButton.icon(
                                icon: const Icon(
                                  Icons.lock_reset,
                                ),
                                label: const Text(
                                  "Change Password",
                                ),
                                onPressed: () {
                                  showDialog(
                                    context:
                                        context,
                                    builder: (_) =>
                                        const ChangePasswordDialog(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Card(
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  22),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  28),
                          child: Column(
                            children: [

                              Row(
                                children: const [

                                  Icon(
                                    Icons.person,
                                  ),

                                  SizedBox(
                                      width: 10),

                                  Text(
                                    "Personal Information",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 30),
                                                            Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          firstNameController,
                                      enabled: editMode,
                                      decoration: decoration(
                                        "First Name",
                                        Icons.person_outline,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "First name is required.";
                                        }

                                        if (value.length > 50) {
                                          return "Maximum 50 characters.";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          lastNameController,
                                      enabled: editMode,
                                      decoration: decoration(
                                        "Last Name",
                                        Icons.badge_outlined,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Last name is required.";
                                        }

                                        if (value.length > 50) {
                                          return "Maximum 50 characters.";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                controller: emailController,
                                enabled: editMode,
                                decoration: decoration(
                                  "Email",
                                  Icons.email_outlined,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return "Email is required.";
                                  }

                                  final regex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$',
                                  );

                                  if (!regex.hasMatch(
                                    value.trim(),
                                  )) {
                                    return "Invalid email.";
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                controller: phoneController,
                                enabled: editMode,
                                decoration: decoration(
                                  "Phone Number",
                                  Icons.phone_outlined,
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                controller:
                                    addressController,
                                enabled: editMode,
                                maxLines: 2,
                                decoration: decoration(
                                  "Address",
                                  Icons.home_outlined,
                                ),
                              ),

                              const SizedBox(height: 32),

                              if (editMode)
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child:
                                      FilledButton.icon(
                                    icon: const Icon(
                                      Icons.save,
                                    ),
                                    label: const Text(
                                      "Save Changes",
                                    ),
                                    onPressed: saving
                                        ? null
                                        : saveProfile,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (saving)
            Container(
              color: Colors.black26,
              child: const Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}