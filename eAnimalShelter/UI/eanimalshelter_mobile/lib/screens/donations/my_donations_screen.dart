import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/donation.dart';
import '../../providers/donation_provider.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  State<MyDonationsScreen> createState() =>
      _MyDonationsScreenState();
}

class _MyDonationsScreenState
    extends State<MyDonationsScreen> {
  List<Donation> _donations = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final provider =
          context.read<DonationProvider>();

      final result =
          await provider.getMyDonations();

      if (!mounted) return;

      setState(() {
        _donations = result.items;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _downloadReceipt(
      Donation donation) async {
    try {
      final provider =
          context.read<DonationProvider>();

      final bytes =
          await provider.downloadReceipt(
        donation.donationId,
      );

      final directory =
          await getApplicationDocumentsDirectory();

      final file = File(
        "${directory.path}/receipt_${donation.donationId}.pdf",
      );

      await file.writeAsBytes(bytes);

      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Color _statusColor(int status) {
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

  String _statusText(int status) {
    switch (status) {
      case 0:
        return "Successful";
      case 1:
        return "Failed";
      case 2:
        return "Pending";
      default:
        return "Unknown";
    }
  }

  IconData _statusIcon(int status) {
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

  double get _totalAmount =>
      _donations.fold(
        0,
        (sum, item) =>
            sum + item.amount,
      );

  int get _successful =>
      _donations
          .where(
              (e) => e.transactionStatus == 0)
          .length;

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final cardWidth =
        width > 700 ? 650.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Donations"),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadDonations,
              child: _donations.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context)
                                      .size
                                      .height *
                                  .18,
                        ),
                        const Icon(
                          Icons.favorite_outline,
                          size: 90,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                            height: 20),
                        const Center(
                          child: Text(
                            "No donations yet",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 10),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                                  horizontal: 40),
                          child: Text(
                            "Every contribution helps us provide food, shelter and medical care.",
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 30),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 50),
                          child:
                              FilledButton.icon(
                            icon: const Icon(
                                Icons.favorite),
                            label: const Text(
                                "Donate now"),
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child:
                          ConstrainedBox(
                        constraints:
                            BoxConstraints(
                          maxWidth:
                              cardWidth,
                        ),
                        child:
                            ListView.builder(
                          padding:
                              const EdgeInsets.all(
                                  20),
                          itemCount:
                              _donations.length +
                                  1,
                          itemBuilder:
                              (context, index) {
                            if (index == 0) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                        bottom:
                                            20),
                                padding:
                                    const EdgeInsets.all(
                                        22),
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                          24),
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Colors.teal,
                                      Color(
                                          0xff4db6ac)
                                    ],
                                  ),
                                ),
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .favorite,
                                          color: Colors
                                              .white,
                                        ),
                                        SizedBox(
                                            width:
                                                8),
                                        Text(
                                          "Donation Summary",
                                          style:
                                              TextStyle(
                                            color:
                                                Colors.white,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize:
                                                18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height:
                                            25),
                                    Text(
                                      "€${_totalAmount.toStringAsFixed(2)}",
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,
                                        fontSize:
                                            34,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              _summaryItem(
                                            "Donations",
                                            _donations
                                                .length
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child:
                                              _summaryItem(
                                            "Successful",
                                            _successful
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }

                            final donation =
                                _donations[
                                    index - 1];
                                                                return Card(
                              elevation: 3,
                              margin:
                                  const EdgeInsets.only(
                                      bottom: 18),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        22),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                        20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor:
                                              _statusColor(
                                                      donation.transactionStatus)
                                                  .withOpacity(
                                                      0.15),
                                          child: Icon(
                                            _statusIcon(
                                                donation.transactionStatus),
                                            color:
                                                _statusColor(
                                                    donation.transactionStatus),
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                "€${donation.amount.toStringAsFixed(2)}",
                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      26,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height:
                                                      4),
                                              Text(
                                                donation.donationDate ==
                                                        null
                                                    ? "-"
                                                    : DateFormat(
                                                            "dd.MM.yyyy • HH:mm")
                                                        .format(
                                                            donation.donationDate!),
                                                style:
                                                    TextStyle(
                                                  color: Colors
                                                      .grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal:
                                                12,
                                            vertical: 7,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: _statusColor(
                                                    donation.transactionStatus)
                                                .withOpacity(
                                                    0.15),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    30),
                                          ),
                                          child: Text(
                                            _statusText(
                                                donation.transactionStatus),
                                            style:
                                                TextStyle(
                                              color: _statusColor(
                                                  donation.transactionStatus),
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 22),
                                    Container(
                                      padding:
                                          const EdgeInsets.all(
                                              16),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .grey.shade50,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    16),
                                      ),
                                      child: Column(
                                        children: [
                                          _infoRow(
                                            Icons.credit_card,
                                            "Payment",
                                            donation
                                                .paymentMethod,
                                          ),
                                          if (donation.note !=
                                                  null &&
                                              donation.note!
                                                  .trim()
                                                  .isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top:
                                                          14),
                                              child:
                                                  _infoRow(
                                                Icons
                                                    .notes,
                                                "Note",
                                                donation
                                                    .note!,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (donation
                                            .receiptPdfPath !=
                                        null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(
                                                top: 22),
                                        child: SizedBox(
                                          width: double
                                              .infinity,
                                          child:
                                              FilledButton.icon(
                                            icon: const Icon(
                                                Icons
                                                    .picture_as_pdf),
                                            label:
                                                const Text(
                                              "Download receipt",
                                            ),
                                            onPressed: () =>
                                                _downloadReceipt(
                                                    donation),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
    ),
    );
    
  }

  Widget _summaryItem(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        )
      ],
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.teal,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}