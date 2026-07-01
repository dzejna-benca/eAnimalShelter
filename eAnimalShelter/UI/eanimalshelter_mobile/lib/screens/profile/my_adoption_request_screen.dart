import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../models/adoption_request.dart';
import '../../providers/adoption_request_provider.dart';
import '../../utils/app_config.dart';
import 'adoption_request_details_screen.dart';

class MyAdoptionRequestsScreen extends StatefulWidget {
  const MyAdoptionRequestsScreen({
    super.key,
  });

  @override
  State<MyAdoptionRequestsScreen> createState() =>
      _MyAdoptionRequestsScreenState();
}

class _MyAdoptionRequestsScreenState
    extends State<MyAdoptionRequestsScreen> {
  bool loading = true;

  List<AdoptionRequest> requests = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
    loading = true;
    });
    try {
      requests = await context
          .read<AdoptionRequestProvider>()
          .getMyRequests();

      requests.sort(
        (a, b) =>
            b.requestDate!.compareTo(
          a.requestDate!,
        ),
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Color getStatusColor(
    String? status,
  ) {
    switch (status) {
      case "Approved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Cancelled":
        return Colors.grey;

      default:
        return Colors.orange;
    }
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
        title: const Text(
          "My Adoption Requests",
        ),
      ),
      body: requests.isEmpty
          ? Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets,
                      size: 90,
                      color:
                          Colors.grey.shade400,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "You haven't submitted any adoption requests yet.",
                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    requests.length,
               itemBuilder: (_, index) {
  final item = requests[index];

  final imagePath =
      item.animal?.images.isNotEmpty == true
          ? item.animal!.images.first.imagePath
          : null;

  return Card(
    margin: const EdgeInsets.only(
      bottom: 16,
    ),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(18),
    ),
    child: InkWell(
      borderRadius:
          BorderRadius.circular(18),
      onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AdoptionRequestDetailsScreen(
            request: item,
          ),
        ),
      );

      if (result == true) {
        await loadData();
      }
    },
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              child: SizedBox(
                width: 90,
                height: 90,
                child: imagePath != null &&
                        imagePath.isNotEmpty
                    ? Image.network(
                        "${AppConfig.baseUrl}$imagePath",
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                Container(
                          color: Colors
                              .grey.shade200,
                          child: const Icon(
                            Icons.pets,
                            size: 35,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors
                            .grey.shade200,
                        child: const Icon(
                          Icons.pets,
                          size: 35,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment:
                        WrapCrossAlignment
                            .center,
                    children: [
                      Text(
                        item.animalName ??
                            "",
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              getStatusColor(
                            item.status,
                          ).withOpacity(
                            0.15,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Text(
                          item.status ?? "",
                          style:
                              TextStyle(
                            color:
                                getStatusColor(
                              item.status,
                            ),
                            fontWeight:
                                FontWeight
                                    .w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Text(
                          "Submitted ${item.requestDate?.day}.${item.requestDate?.month}.${item.requestDate?.year}",
                          style:
                              TextStyle(
                            color: Colors
                                .grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if ((item.adminComment ??
                          "")
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets
                              .all(10),
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .grey.shade100,
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              item.adminComment!,
                              maxLines: 2,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                fontSize:
                                    13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 8,
                  ),

                  Align(
                    alignment:
                        Alignment
                            .centerRight,
                    child:
                        TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdoptionRequestDetailsScreen(
                              request: item,
                            ),
                          ),
                        );

                        if (result == true) {
                          await loadData();
                        }
                      },
                      icon: const Icon(
                        Icons
                            .arrow_forward_ios,
                        size: 14,
                      ),
                      label: const Text(
                        "View Details",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
        ),
      ),
    ),
  );
},
              ),
          ),
    );
    }
    }