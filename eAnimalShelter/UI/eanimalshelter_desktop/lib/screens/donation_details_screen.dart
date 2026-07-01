import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/donation.dart';
import '../providers/donation_provider.dart';
import '../widgets/master_screen.dart';

class DonationDetailsScreen extends StatefulWidget {
  final int donationId;

  const DonationDetailsScreen({
    super.key,
    required this.donationId,
  });

  @override
  State<DonationDetailsScreen> createState() =>
      _DonationDetailsScreenState();
}

class _DonationDetailsScreenState
    extends State<DonationDetailsScreen> {
  late DonationProvider _provider;

  Donation? donation;

  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _provider = context.read<DonationProvider>();

    _loadDonation();
  }

  Future<void> _loadDonation() async {
    try {
      var result = await _provider.getById(
        widget.donationId,
      );

      setState(() {
        donation = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
     if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Successful";
      case 1:
        return "Failed";
      case 2:
        return "Pending";
      default:
        return "-";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  List<Color> getStatusGradient(int status) {
    switch (status) {
      case 0:
        return [
          const Color(0xFF2E7D32),
          const Color(0xFF66BB6A),
        ];

      case 1:
        return [
          const Color(0xFFC62828),
          const Color(0xFFEF5350),
        ];

      case 2:
        return [
          const Color(0xFFEF6C00),
          const Color(0xFFFFB74D),
        ];

      default:
        return [
          Colors.grey.shade700,
          Colors.grey.shade400,
        ];
    }
  }

  IconData getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.check_circle;

      case 1:
        return Icons.cancel;

      case 2:
        return Icons.schedule;

      default:
        return Icons.help_outline;
    }
  }

  Widget buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Donation Details",
      showBackButton: true,
      child: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : donation == null
              ? const Center(
                  child: Text(
                    "Donation not found",
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      /// HERO CARD
                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(28),
                        decoration:
                            BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: getStatusGradient(
                              donation!.transactionStatus,
                            ),
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            24,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              getStatusIcon(
                                donation!.transactionStatus,
                              ),
                              color: Colors.white,
                              size: 42,
                            ),
                            const SizedBox(
                                height: 12),
                            Text(
                              "${donation!.amount?.toStringAsFixed(2) ?? "0.00"} KM",
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            const SizedBox(
                                height: 10),
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    14,
                                vertical: 7,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white24,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                getStatusText(
                                  donation!
                                      .transactionStatus,
                                ),
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 30),

                      Text(
                        "Donation Information",
                        style:
                            Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                      ),

                      const SizedBox(
                          height: 20),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        crossAxisSpacing:
                            16,
                        mainAxisSpacing:
                            16,
                        childAspectRatio:
                            3.4,
                        children: [
                          buildInfoTile(
                            icon:
                                Icons.person,
                            title: "Donor",
                            value: donation!
                                    .userFullName ??
                                "-",
                          ),
                          buildInfoTile(
                            icon: Icons
                                .payments,
                            title:
                                "Payment Method",
                            value: donation!
                                    .paymentMethod ??
                                "-",
                          ),
                          buildInfoTile(
                            icon:
                                Icons.calendar_today,
                            title:
                                "Donation Date",
                            value: donation!
                                    .donationDate
                                    ?.toString()
                                    .split(
                                        " ")
                                    .first ??
                                "-",
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 25),

                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(20),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      0.05),
                              blurRadius:
                                  12,
                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .info_outline,
                                  color:
                                      getStatusColor(
                                    donation!
                                        .transactionStatus,
                                  ),
                                ),
                                const SizedBox(
                                    width: 8),
                                const Text(
                                  "Transaction Status",
                                  style:
                                      TextStyle(
                                    fontSize:
                                        17,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 15),
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    16,
                                vertical: 8,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    getStatusColor(
                                  donation!
                                      .transactionStatus,
                                ).withOpacity(
                                  0.15,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  30,
                                ),
                              ),
                              child: Text(
                                getStatusText(
                                  donation!
                                      .transactionStatus,
                                ),
                                style:
                                    TextStyle(
                                  color:
                                      getStatusColor(
                                    donation!
                                        .transactionStatus,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 25),

                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(20),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      0.05),
                              blurRadius:
                                  12,
                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.notes,
                                ),
                                SizedBox(
                                    width: 8),
                                Text(
                                  "Note",
                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 12),
                            Text(
                              donation!.note
                                          ?.trim()
                                          .isNotEmpty ==
                                      true
                                  ? donation!
                                      .note!
                                  : "No note provided.",
                              style:
                                  const TextStyle(
                                height:
                                    1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 25),

                      if (donation!
                              .receiptPdfPath !=
                          null)
                        Container(
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                        0.05),
                                blurRadius:
                                    12,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets
                                    .all(16),
                            leading:
                                Container(
                              padding:
                                  const EdgeInsets
                                      .all(10),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .red
                                    .withOpacity(
                                        0.1),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .picture_as_pdf,
                                color: Colors
                                    .red,
                              ),
                            ),
                            title:
                                const Text(
                              "Receipt PDF",
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            subtitle:
                                Text(
                              donation!
                                  .receiptPdfPath!,
                            ),
                            trailing:
                                const Icon(
                              Icons
                                  .arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}