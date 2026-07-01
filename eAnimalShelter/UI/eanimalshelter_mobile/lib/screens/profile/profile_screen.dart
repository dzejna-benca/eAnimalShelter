import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/user_update_request.dart';
import '../../providers/profile_provider.dart';
import 'change_password_screen.dart';
import 'my_adoption_request_screen.dart';

class ProfileScreen extends StatefulWidget {
   final bool showAdoptionRequests;
  const ProfileScreen({super.key,
    this.showAdoptionRequests = true,});


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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
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
        title: const Text(
          "Confirm Changes",
        ),
        content: const Text(
          "Are you sure you want to save the changes to your profile?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text(
              "Cancel",
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text(
              "Save",
            ),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      setState(() {
        saving = true;
      });

      final updatedUser =
          await context
              .read<ProfileProvider>()
              .updateProfile(
                UserUpdateRequest(
                  firstName:
                      firstNameController.text
                          .trim(),
                  lastName:
                      lastNameController.text
                          .trim(),
                  email:
                      emailController.text
                          .trim(),
                  phoneNumber:
                      phoneController.text
                              .trim()
                              .isEmpty
                          ? null
                          : phoneController.text
                              .trim(),
                  address:
                      addressController.text
                              .trim()
                              .isEmpty
                          ? null
                          : addressController.text
                              .trim(),
                  isActive:
                      user?.isActive ??
                      true,
                  roleId:
                      user?.roleId ?? 0,
                ),
              );

      if (!mounted) return;

      setState(() {
        user = updatedUser;
        editMode = false;
      });

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Profile Updated",
          ),
          content: const Text(
            "Your profile information has been updated successfully.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll(
              "Exception: ",
              "",
            ),
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
            BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isTablet = width > 700;

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
          SingleChildScrollView(
            padding: EdgeInsets.all(
              isTablet ? 32 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 850,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  child: Text(
                                    (user?.firstName?.isNotEmpty ?? false)
                                        ? user!.firstName![0].toUpperCase()
                                        : "U",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      Text(user?.email ?? ""),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.lock_reset,
                                ),
                                label: const Text(
                                  "Change Password",
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ChangePasswordScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                      const SizedBox(
                        height: 24,
                      ),
                      if (widget.showAdoptionRequests)...[
                      Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.pets,
                        ),
                        title: const Text(
                          "My Adoption Requests",
                        ),
                        subtitle: const Text(
                          "View all submitted requests",
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MyAdoptionRequestsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                      

                    const SizedBox(
                        height: 24,
                      ),
                      ],

                      TextFormField(
                        controller:
                            firstNameController,
                        enabled: editMode,
                        decoration:
                            decoration(
                          "First Name",
                          Icons.person,
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return "First name is required.";
                          }

                          if (value
                                  .length >
                              50) {
                            return "Maximum 50 characters.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller:
                            lastNameController,
                        enabled: editMode,
                        decoration:
                            decoration(
                          "Last Name",
                          Icons.person_outline,
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return "Last name is required.";
                          }

                          if (value
                                  .length >
                              50) {
                            return "Maximum 50 characters.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller:
                            emailController,
                        enabled: editMode,
                        decoration:
                            decoration(
                          "Email",
                          Icons.email,
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return "Email is required.";
                          }

                          final regex =
                              RegExp(
                            r'^[^@]+@[^@]+\.[^@]+$',
                          );

                          if (!regex
                              .hasMatch(
                            value.trim(),
                          )) {
                            return "Invalid email format.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller:
                            phoneController,
                        enabled: editMode,
                        decoration:
                            decoration(
                          "Phone Number",
                          Icons.phone,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller:
                            addressController,
                        enabled: editMode,
                        maxLines: 2,
                        decoration:
                            decoration(
                          "Address",
                          Icons.home,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      if (editMode)
                        SizedBox(
                          width:
                              double.infinity,
                          height: 55,
                          child:
                              ElevatedButton.icon(
                            icon: const Icon(
                              Icons.save,
                            ),
                            onPressed:
                                saving
                                    ? null
                                    : saveProfile,
                            label: const Text(
                              "Save Changes",
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