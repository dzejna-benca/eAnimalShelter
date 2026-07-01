import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/volunteer_assignment.dart';
import '../../providers/volunteer_assignment_provider.dart';

enum AssignmentFilter {
  all,
  pending,
  approved,
  completed,
}

class VolunteerMyActivitiesScreen extends StatefulWidget {
  const VolunteerMyActivitiesScreen({super.key});

  @override
  State<VolunteerMyActivitiesScreen> createState() =>
      _VolunteerMyActivitiesScreenState();
}

class _VolunteerMyActivitiesScreenState
    extends State<VolunteerMyActivitiesScreen> {
  bool _loading = true;

  List<VolunteerAssignment> _assignments = [];

  AssignmentFilter _selectedFilter =
      AssignmentFilter.all;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _loading = true;
    });

    try {
      final provider =
          context.read<VolunteerAssignmentProvider>();

      int? status;

      switch (_selectedFilter) {
        case AssignmentFilter.pending:
          status = 0;
          break;

        case AssignmentFilter.approved:
          status = 1;
          break;

        case AssignmentFilter.completed:
          status = 4;
          break;

        case AssignmentFilter.all:
          status = null;
          break;
      }

      final result = await provider.get(
        filter: {
          "status": status,
        },
      );

      if (!mounted) return;

      setState(() {
        _assignments = result.items!;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
  bool canCancel(VolunteerAssignment assignment) {
  final activity = assignment.activityStartDateTime;

  if (activity == null) return false;

  return activity.isAfter(
    DateTime.now().add(
      const Duration(days: 2),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [

        const SizedBox(height: 16),

        SizedBox(
          height: 42,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [

              _buildFilterChip(
                "All",
                AssignmentFilter.all,
              ),

              _buildFilterChip(
                "Pending",
                AssignmentFilter.pending,
              ),

              _buildFilterChip(
                "Approved",
                AssignmentFilter.approved,
              ),

              _buildFilterChip(
                "Completed",
                AssignmentFilter.completed,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Expanded(
          child: _assignments.isEmpty
              ? const Center(
                  child: Text(
                    "No applications found.",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAssignments,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: _assignments.length,
                    itemBuilder: (_, index) {
                      return _buildCard(
                        _assignments[index],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String title,
    AssignmentFilter filter,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(title),
        selected: _selectedFilter == filter,
        onSelected: (_) {
          setState(() {
            _selectedFilter = filter;
          });

          _loadAssignments();
        },
      ),
    );
  }
    Widget _buildCard(
    VolunteerAssignment assignment,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    assignment.activityTitle ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                _buildStatusChip(
                  assignment.status,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Text(
                  "Applied ${DateFormat("dd.MM.yyyy").format(
                    assignment.appliedAt,
                  )}",
                ),
              ],
            ),

            if (assignment.applicationNote != null &&
                assignment.applicationNote!
                    .trim()
                    .isNotEmpty) ...[

              const SizedBox(height: 16),

              const Text(
                "Application note",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                assignment.applicationNote!,
              ),
            ],

            if (assignment.hoursWorked > 0) ...[

              const SizedBox(height: 16),

              Row(
                children: [

                  const Icon(
                    Icons.schedule,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "Hours worked: ${assignment.hoursWorked}",
                  ),
                ],
              ),
            ],

            if (assignment.adminResponseReason != null &&
                assignment.adminResponseReason!
                    .trim()
                    .isNotEmpty) ...[

              const SizedBox(height: 16),

              const Text(
                "Admin note",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                assignment.adminResponseReason!,
              ),
            ],

            if ((assignment.status == 0 ||
                assignment.status == 1) &&
            canCancel(assignment)) ...[
          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => _cancelAssignment(
                assignment,
              ),
              label: const Text(
                "Cancel application",
              ),
            ),
          ),
        ]
        else if ((assignment.status == 0 ||
                  assignment.status == 1) &&
            !canCancel(assignment)) ...[
          const SizedBox(height: 16),

          Row(
            children: const [
              Icon(
                Icons.info_outline,
                size: 18,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Applications can only be cancelled more than 2 days before the activity starts.",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildStatusChip(int status) {
    return Chip(
      label: Text(
        _statusText(status),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor:
          _statusColor(status),
    );
  }

  Color _statusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;

      case 1:
        return Colors.green;

      case 2:
        return Colors.red;

      case 3:
        return Colors.grey;

      case 4:
        return Colors.blue;

      default:
        return Colors.black54;
    }
  }

  String _statusText(int status) {
    switch (status) {
      case 0:
        return "Pending";

      case 1:
        return "Approved";

      case 2:
        return "Rejected";

      case 3:
        return "Cancelled";

      case 4:
        return "Completed";

      default:
        return "";
    }
  }

  Future<void> _cancelAssignment(
      VolunteerAssignment assignment) async {

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Cancel application",
        ),
        content: const Text(
          "Are you sure you want to cancel your application?",
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

          FilledButton(
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

    if (confirm != true) return;

    try {

      await context
          .read<
              VolunteerAssignmentProvider>()
          .cancel(
            assignment.assignmentId,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Application cancelled successfully.",
          ),
        ),
      );

      _loadAssignments();

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll(
              "Exception: ",
              "",
            ),
          ),
        ),
      );
    }
  }
}