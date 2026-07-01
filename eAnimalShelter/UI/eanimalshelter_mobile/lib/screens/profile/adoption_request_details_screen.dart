import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/adoption_request.dart';
import '../../providers/adoption_request_provider.dart';

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
  bool loading = false;

  Color getStatusColor(
    String? status,
  ) {
    switch (status?.toLowerCase()) {
      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      case "cancelled":
        return Colors.grey;

      default:
        return Colors.orange;
    }
  }

  Future<void> cancelRequest() async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Cancel Request",
            ),
            content: const Text(
              "Are you sure you want to cancel this adoption request?",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  false,
                ),
                child: const Text(
                  "No",
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(
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

    if (confirm != true) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await context
          .read<
              AdoptionRequestProvider>()
          .cancelRequest(
            widget.request
                .adoptionRequestId!,
          );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Request Cancelled",
          ),
          content: const Text(
            "Your adoption request has been successfully cancelled.",
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

      Navigator.pop(
        context,
        true,
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
          loading = false;
        });
      }
    }
  }

  Widget buildInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isTablet = width > 700;

    final request = widget.request;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request Details",
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
                child: Card(
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
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          request
                                  .animalName ??
                              "Animal",
                          style:
                              const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        buildInfoRow(
                          "Request Date",
                          request.requestDate ==
                                  null
                              ? "-"
                              : "${request.requestDate!.day}.${request.requestDate!.month}.${request.requestDate!.year}",
                        ),

                        buildInfoRow(
                          "Housing Type",
                          request
                                  .housingType ??
                              "-",
                        ),

                        buildInfoRow(
                          "Experience",
                          request
                                  .experienceWithPets ??
                              "-",
                        ),

                        buildInfoRow(
                          "Household Members",
                          request
                                  .householdMembers
                                  ?.toString() ??
                              "-",
                        ),

                        buildInfoRow(
                          "Additional Notes",
                          request
                                      .additionalNotes ==
                                  null
                              ? "-"
                              : request
                                  .additionalNotes!,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        const Text(
                          "Status",
                          style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Chip(
                          label: Text(
                            request.status ??
                                "",
                          ),
                          backgroundColor:
                              getStatusColor(
                            request.status,
                          ).withOpacity(
                            0.15,
                          ),
                        ),

                        if ((request
                                    .adminComment ??
                                "")
                            .isNotEmpty)
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const SizedBox(
                                height:
                                    24,
                              ),

                              const Text(
                                "Shelter Comment",
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize:
                                      16,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    8,
                              ),

                              Container(
                                width:
                                    double.infinity,
                                padding:
                                    const EdgeInsets.all(
                                  14,
                                ),
                                decoration:
                                    BoxDecoration(
                                  border:
                                      Border.all(
                                    color: Colors
                                        .grey,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                child: Text(
                                  request.adminComment!,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(
                          height: 30,
                        ),

                        if (request
                                .status
                                ?.toLowerCase() ==
                            "pending")
                          SizedBox(
                            width:
                                double.infinity,
                            height: 55,
                            child:
                                ElevatedButton.icon(
                              icon:
                                  const Icon(
                                Icons.close,
                              ),
                              onPressed:
                                  loading
                                      ? null
                                      : cancelRequest,
                              label:
                                  const Text(
                                "Cancel Request",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (loading)
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