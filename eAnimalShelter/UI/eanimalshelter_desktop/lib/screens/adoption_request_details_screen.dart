import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/adoption_request.dart';
import '../providers/adoption_request_provider.dart';
import '../utils/app_config.dart';
import '../utils/dialog_helper.dart';
import '../utils/message_helper.dart';

class AdoptionRequestDetailsScreen
    extends StatefulWidget {

  final AdoptionRequest request;

  const AdoptionRequestDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  State<AdoptionRequestDetailsScreen>
      createState() =>
          _AdoptionRequestDetailsScreenState();
}

class _AdoptionRequestDetailsScreenState
    extends State<
        AdoptionRequestDetailsScreen> {

  late AdoptionRequestProvider
      _provider;

  late TextEditingController
      _commentController;

  @override
  void initState() {
    super.initState();

    _commentController =
        TextEditingController(
      text:
          widget.request.adminComment ??
              "",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _provider =
        context.read<
            AdoptionRequestProvider>();
  }

  String getStatusText(
      int status) {
    switch (status) {
      case 0:
        return "Pending";

      case 1:
        return "Approved";

      case 2:
        return "Rejected";

      case 3:
        return "Cancelled";

      default:
        return "-";
    }
  }

  
 Future<void> _approve() async {
    bool confirmed =
        await DialogHelper.confirmAction(
      context,
      title: "Approve Request",
      message:
          "Are you sure you want to approve this adoption request?",
      confirmText: "Approve",
    );

    if (!mounted) return;

    if (!confirmed) return;

    try {
      await _provider.approve(
        widget.request.adoptionRequestId,
        _commentController.text,
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
  Future<void> _reject() async {
    bool confirmed =
        await DialogHelper.confirmAction(
      context,
      title: "Reject Request",
      message:
          "Are you sure you want to reject this adoption request?",
      confirmText: "Reject",
      isDestructive: true,
    );

    if (!mounted) return;

    if (!confirmed) return;

    try {
      await _provider.reject(
        widget.request.adoptionRequestId,
        _commentController.text,
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
  Widget build(BuildContext context) {
    final request = widget.request;
    final bool canEditComment = request.status == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adoption Request Details",
        ),
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(24),
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ),
      child: Column(
        children: [

          // HEADER
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.assignment,
                    size: 45,
                    color: Colors.teal,
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.animalName ?? "",
                          style:
                              const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Request #${request.adoptionRequestId}",
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          getStatusColor(
                            request.status,
                          ).withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      getStatusText(
                        request.status,
                      ),
                      style: TextStyle(
                        color:
                            getStatusColor(
                              request.status,
                            ),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // APPLICANT + ANIMAL
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Card(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        const Row(
                          children: [
                            Icon(
                              Icons.person,
                              color:
                                  Colors.teal,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Applicant Information",
                              style:
                                  TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        ListTile(
                          leading: const Icon(
                            Icons.person,
                          ),
                          title: Text(
                            "${request.user?.firstName ?? ""} ${request.user?.lastName ?? ""}"
                                .trim(),
                          ),
                          subtitle: const Text(
                            "Full Name",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.badge,
                          ),
                          title: Text(
                            request.userName ??
                                "",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.email,
                          ),
                          title: Text(
                            request.user?.email ??
                                "-",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.phone,
                          ),
                          title: Text(
                            request.user
                                    ?.phoneNumber ??
                                "-",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.location_on,
                          ),
                          title: Text(
                            request.user
                                    ?.address ??
                                "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Card(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        const Row(
                          children: [
                            Icon(
                              Icons.pets,
                              color:
                                  Colors.teal,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Animal Information",
                              style:
                                  TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        if (request
                                .animal
                                ?.images
                                .isNotEmpty ==
                            true)
                          Center(
                            child:
                                ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                              child:
                                  Image.network(
                                "${AppConfig.baseUrl}${request.animal!.images.first.imagePath}",
                                height:
                                    220,
                              ),
                            ),
                          ),

                        const SizedBox(
                            height: 15),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.pets,
                          ),
                          title: Text(
                            request
                                    .animal
                                    ?.name ??
                                "",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.category,
                          ),
                          title: Text(
                            request
                                    .animal
                                    ?.speciesName ??
                                "-",
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons.label,
                          ),
                          title: Text(
                            request
                                    .animal
                                    ?.breedName ??
                                "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ADOPTION INFO
          Card(
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Adoption Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    title: const Text(
                        "Housing Type"),
                    subtitle: Text(
                      request.housingType,
                    ),
                  ),

                  ListTile(
                    title: const Text(
                        "Experience With Pets"),
                    subtitle: Text(
                      request
                          .experienceWithPets,
                    ),
                  ),

                  ListTile(
                    title: const Text(
                        "Household Members"),
                    subtitle: Text(
                      request
                          .householdMembers
                          .toString(),
                    ),
                  ),

                  ListTile(
                    title: const Text(
                        "Additional Notes"),
                    subtitle: Text(
                      request
                              .additionalNotes ??
                          "-",
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // REVIEW
          Card(
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [

                  TextField(
                    controller: _commentController,
                    enabled: canEditComment,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Admin Comment",
                      border: const OutlineInputBorder(),
                      filled: !canEditComment,
                      fillColor: !canEditComment
                          ? Colors.grey.shade100
                          : null,
                      helperText: canEditComment
                          ? "Enter review comment"
                          : "Comment can no longer be edited",
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  if (canEditComment)
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [

                        ElevatedButton.icon(
                          onPressed: _reject,
                          icon: const Icon(Icons.close),
                          label: const Text("Reject"),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton.icon(
                          onPressed: _approve,
                          icon: const Icon(Icons.check),
                          label: const Text("Approve"),
                        ),
                      ],
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
    );
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;

      case 1:
        return Colors.green;

      case 2:
        return Colors.red;

      case 3:
        return Colors.grey;

      default:
        return Colors.black;
    }
  }
}