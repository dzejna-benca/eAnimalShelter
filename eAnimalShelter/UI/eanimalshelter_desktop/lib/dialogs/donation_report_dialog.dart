import 'package:flutter/material.dart';

import '../models/donation_report.dart';
import '../providers/auth_provider.dart';
import '../utils/donation_report_pdf.dart';

class DonationReportDialog extends StatelessWidget {
  final DonationReport report;

  const DonationReportDialog({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 850,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.assessment,
                    color: Colors.teal,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Donation Report",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon:
                        const Icon(Icons.close),
                  )
                ],
              ),

              const Divider(height: 30),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Total Donations",
                      value:
                          "${report.totalDonations.toStringAsFixed(2)} KM",
                      icon: Icons.payments,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Average Donation",
                      value:
                          "${report.averageDonation.toStringAsFixed(2)} KM",
                      icon: Icons.analytics,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              _buildSummaryCard(
                title: "Top Donor",
                value: report.topDonor,
                icon: Icons.emoji_events,
              ),

              const SizedBox(height: 30),

              const Text(
                "Donations By Month",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children:
                        report.donationsByMonth.entries
                            .map(
                              (entry) =>
                                  Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        entry.key,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                          LinearProgressIndicator(
                                        value:
                                            _calculateProgress(
                                          entry.value
                                              .toDouble(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 15),
                                    Text(
                                      "${entry.value.toStringAsFixed(2)} KM",
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),
                    label:
                        const Text("Export PDF"),
                    onPressed: () async {
                      await generateDonationReportPdf(
                      report,
                      AuthProvider.fullName,
                    );
                    },
                  ),

                  const SizedBox(width: 10),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("Close"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.teal,
              size: 34,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
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

  double _calculateProgress(
      double value) {
    if (report.donationsByMonth.isEmpty) {
      return 0;
    }

    double max =
        report.donationsByMonth.values
            .map((e) => e.toDouble())
            .reduce(
              (a, b) => a > b ? a : b,
            );

    if (max == 0) return 0;

    return value / max;
  }
}