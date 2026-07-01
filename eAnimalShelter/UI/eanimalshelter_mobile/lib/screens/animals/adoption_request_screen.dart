import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/adoption_request_insert_request.dart';
import '../../models/animal.dart';
import '../../models/user.dart';
import '../../providers/adoption_request_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/app_config.dart';

class AdoptionRequestScreen extends StatefulWidget {
  final Animal animal;

  const AdoptionRequestScreen({
    super.key,
    required this.animal,
  });

  @override
  State<AdoptionRequestScreen> createState() =>
      _AdoptionRequestScreenState();
}

class _AdoptionRequestScreenState
    extends State<AdoptionRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final housingController =
      TextEditingController();

  final experienceController =
      TextEditingController();

  final additionalController =
      TextEditingController();

  User? user;

  bool profileLoading = true;
  bool isLoading = false;

  int householdMembers = 1;

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

      if (!mounted) return;

      setState(() {
        user = result;
        profileLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        profileLoading = false;
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if ((user?.phoneNumber ?? "")
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Please add your phone number in your profile before submitting an adoption request.",
          ),
        ),
      );
      return;
    }

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Submit Adoption Request",
            ),
            content: Text(
            "Are you sure you want to submit this adoption request? Once submitted, it will be reviewed by the shelter staff.",
          ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  false,
                ),
                child: const Text(
                  "Cancel",
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  true,
                ),
                child: const Text(
                  "Submit",
                ),
              ),
            ],
          ),
        );

    if (confirmed != true) return;

    try {
      setState(() {
        isLoading = true;
      });

      await context
          .read<
            AdoptionRequestProvider
          >()
          .submitRequest(
            AdoptionRequestInsertRequest(
              animalId:
                  widget.animal.animalId,
              housingType:
                  housingController.text
                      .trim(),
              experienceWithPets:
                  experienceController
                      .text
                      .trim(),
              householdMembers:
                  householdMembers,
              additionalNotes:
                  additionalController
                          .text
                          .trim()
                          .isEmpty
                      ? null
                      : additionalController
                          .text
                          .trim(),
            ),
          );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Request Submitted",
          ),
          content: Text(
            "Your adoption request for ${widget.animal.name} has been successfully submitted.\n\nOur shelter team will review your application and contact you as soon as possible.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(
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

      Navigator.pop(context);
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
          isLoading = false;
        });
      }
    }
  }

  InputDecoration fieldDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isTablet = width > 700;

    if (profileLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adoption Request",
        ),
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
                  maxWidth: 900,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Card(
                        elevation: 3,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                child: Text(
                                  (user?.firstName?.isNotEmpty ?? false)
                                      ? user!.firstName![0].toUpperCase()
                                      : "U",
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
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
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize:
                                            18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height:
                                          4,
                                    ),
                                    Text(
                                      user?.email ??
                                          "",
                                    ),
                                    Text(
                                      (user?.phoneNumber
                                                  ?.trim()
                                                  .isNotEmpty ??
                                              false)
                                          ? user!
                                              .phoneNumber!
                                          : "Phone number not provided",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if ((user?.phoneNumber ??
                              "")
                          .trim()
                          .isEmpty)
                        Container(
                          margin:
                              const EdgeInsets.only(
                            top: 16,
                          ),
                          padding:
                              const EdgeInsets.all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .orange
                                .shade100,
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "Please add a phone number to your profile before submitting an adoption request.",
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(
                        height: 24,
                      ),

                      Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12),
                              child:
                                  widget.animal.images.isNotEmpty
                                      ? Image.network(
                                          "${AppConfig.baseUrl}${widget.animal.images.first.imagePath}",
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  Container(
                                            width: 70,
                                            height: 70,
                                            color:
                                                Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.pets,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 70,
                                          height: 70,
                                          color:
                                              Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.pets,
                                          ),
                                        ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Adoption Application",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    widget.animal.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  Text(
                                    "${widget.animal.speciesName ?? ""} • ${widget.animal.breedName ?? ""}",
                                    style: TextStyle(
                                      color:
                                          Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                      const SizedBox(
                        height: 24,
                      ),

                      TextFormField(
                        controller:
                            housingController,
                        decoration:
                            fieldDecoration(
                          "Housing Type",
                          Icons.home,
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return "Housing type is required.";
                          }

                          if (value
                                  .trim()
                                  .length <
                              5) {
                            return "Housing type must contain at least 5 characters.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      TextFormField(
                        controller:
                            experienceController,
                        maxLines: 5,
                        decoration:
                            fieldDecoration(
                          "Experience With Pets",
                          Icons.favorite,
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return "Experience with pets is required.";
                          }

                          if (value
                                  .trim()
                                  .length <
                              10) {
                            return "Please provide more details about your experience.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Text(
                              "Household Members",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: householdMembers > 1
                                ? () {
                                    setState(() {
                                      householdMembers--;
                                    });
                                  }
                                : null,
                            icon: const Icon(
                              Icons.remove_circle_outline,
                            ),
                          ),

                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              householdMembers.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: householdMembers < 20
                                ? () {
                                    setState(() {
                                      householdMembers++;
                                    });
                                  }
                                : null,
                            icon: const Icon(
                              Icons.add_circle_outline,
                            ),
                          ),
                        ],
                      ),
                    ),

                      const SizedBox(
                        height: 18,
                      ),

                      TextFormField(
                        controller:
                            additionalController,
                        maxLines: 4,
                        decoration:
                            fieldDecoration(
                          "Additional Notes (Optional)",
                          Icons.notes,
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 56,
                        child:
                            ElevatedButton.icon(
                          icon: const Icon(
                            Icons.favorite,
                          ),
                          onPressed:
                              isLoading
                                  ? null
                                  : submit,
                          label: const Text(
                            "Submit Adoption Request",
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
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