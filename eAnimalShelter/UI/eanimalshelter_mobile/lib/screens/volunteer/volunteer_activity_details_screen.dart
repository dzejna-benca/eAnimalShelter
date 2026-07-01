import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/volunteer_activity.dart';
import '../../models/volunteer_activity_details.dart';
import '../../providers/volunteer_activity_provider.dart';
import 'volunteer_apply_screen.dart';

class VolunteerActivityDetailsScreen extends StatefulWidget {
  final VolunteerActivity activity;

  const VolunteerActivityDetailsScreen({
    super.key,
    required this.activity,
  });

  @override
  State<VolunteerActivityDetailsScreen> createState() =>
      _VolunteerActivityDetailsScreenState();
}

class _VolunteerActivityDetailsScreenState
    extends State<VolunteerActivityDetailsScreen> {
  VolunteerActivityDetails? _details;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
  setState(() {
    _loading = true;
  });

  try {
    final provider =
        context.read<VolunteerActivityProvider>();

    final details = await provider.getDetails(
      widget.activity.activityId,
    );

    if (!mounted) return;

    setState(() {
      _details = details;
    });
  } finally {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_details == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Unable to load activity.",
          ),
        ),
      );
    }
    final isFull = widget.activity.currentVolunteers >=
    widget.activity.maxVolunteers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Activity Details",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              _details!.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.location_on_outlined,
                      "Location",
                      _details!.locationName,
                    ),

                    const SizedBox(height: 16),

                    _infoRow(
                      Icons.calendar_today,
                      "Date",
                      DateFormat(
                        "dd.MM.yyyy",
                      ).format(
                        _details!.startDateTime,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _infoRow(
                      Icons.access_time,
                      "Time",
                      "${DateFormat("HH:mm").format(_details!.startDateTime)} - "
                          "${DateFormat("HH:mm").format(_details!.endDateTime)}",
                    ),

                    const SizedBox(height: 16),

                    _infoRow(
                      Icons.people_outline,
                      "Volunteers",
                      "${widget.activity.currentVolunteers}/${widget.activity.maxVolunteers}",
                    ),

                    const SizedBox(height: 16),

                    _infoRow(
                      Icons.person_outline,
                      "Organizer",
                      _details!.createdByUserName,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _details!.description,
              style: const TextStyle(
                height: 1.5,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            if (isFull && !_details!.isApplied) ...[
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      border: Border.all(color: Colors.orange),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.orange,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Activity is currently full. You can still apply and be placed on the waiting list.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 16),
],

if (_details!.isApplied) ...[
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "You have already applied for this activity.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 16),
],

SizedBox(
  width: double.infinity,
  child: FilledButton(
    onPressed: _details!.isApplied
        ? null
        : () async {
            final applied = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => VolunteerApplyScreen(
                  activity: widget.activity,
                ),
              ),
            );

            if (applied == true) {
              await _loadDetails();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Application submitted successfully.",
                  ),
                ),
              );
            }
          },
    child: Text(
      _details!.isApplied
          ? "Already Applied"
          : "Apply",
    ),
  ),
),
          ],
        ),
      ),
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
        Icon(icon),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}