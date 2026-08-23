import 'package:flutter/material.dart';
import '../models/adoption_report.dart';
import '../providers/auth_provider.dart';
import '../utils/adoption_report_pdf.dart';

class AdoptionReportDialog extends StatelessWidget {
  final AdoptionReport report;

  const AdoptionReportDialog({
    super.key,
    required this.report,
  });

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Pending";
      case "approved":
        return "Approved";
      case "rejected":
        return "Rejected";
      case "cancelled":
        return "Cancelled";
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    final requestsByStatus = {
      "Pending": report.pendingRequests,
      "Approved": report.approvedRequests,
      "Rejected": report.rejectedRequests,
      "Cancelled": report.cancelledRequests,
    };

    final double approvalRate =
        report.totalRequests == 0
            ? 0
            : (report.approvedRequests * 100) /
                report.totalRequests;

    double calculateProgress(int value) {
      if (requestsByStatus.isEmpty) return 0;

      int max = requestsByStatus.values.reduce(
        (a, b) => a > b ? a : b,
      );

      if (max == 0) return 0;

      return value / max;
    }

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
                    Icons.assignment,
                    color: Colors.teal,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Adoption Report",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const Divider(height: 30),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Total Requests",
                      value:
                          report.totalRequests.toString(),
                      icon: Icons.list_alt,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildSummaryCard(
                      title: "Approval Rate",
                      value:
                          "${approvalRate.toStringAsFixed(1)} %",
                      icon:
                          Icons.check_circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Requests By Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children:
                        requestsByStatus.entries.map(
                      (entry) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  _statusText(
                                      entry.key),
                                  style: TextStyle(
                                    color:
                                        _statusColor(
                                            entry.key),
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              Expanded(
                                child:
                                    LinearProgressIndicator(
                                  value:
                                      calculateProgress(
                                    entry.value,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 15),

                              Text(
                                entry.value
                                    .toString(),
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
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
                    label: const Text(
                        "Export PDF"),
                    onPressed: () async {
                      await generateAdoptionReportPdf(
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
}