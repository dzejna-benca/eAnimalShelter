import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/volunteer_activity_details.dart';
import '../models/volunteer_assignment.dart';
import '../providers/volunteer_activity_provider.dart';
import '../providers/volunteer_assignment_provider.dart';
import '../utils/message_helper.dart';
import '../widgets/master_screen.dart';

class VolunteerActivityDetailsScreen extends StatefulWidget {
  final int activityId;

  const VolunteerActivityDetailsScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<VolunteerActivityDetailsScreen> createState() =>
      _VolunteerActivityDetailsScreenState();
}

class _VolunteerActivityDetailsScreenState
    extends State<VolunteerActivityDetailsScreen> {
  late VolunteerActivityProvider _activityProvider;
  late VolunteerAssignmentProvider _assignmentProvider;

  VolunteerActivityDetails? _activity;

  bool _loading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      _activityProvider =
          context.read<VolunteerActivityProvider>();
      _assignmentProvider =
          context.read<VolunteerAssignmentProvider>();

      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      var result =
          await _activityProvider.getDetails(widget.activityId);

      if (!mounted) return;

      setState(() {
        _activity = result;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day.toString().padLeft(2, '0')}."
        "${date.month.toString().padLeft(2, '0')}."
        "${date.year}";
  }

  String getAssignmentStatusText(int? status) {
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
        return "-";
    }
  }

  Color getAssignmentStatusColor(int? status) {
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
        return Colors.grey;
    }
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await _loadData();
  }

  Future<String?> _enterReason(String title) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "Reason",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(context, controller.text.trim());
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

 Future<void> _approveAssignment(
  VolunteerAssignment assignment,
) async {
  final reason =
      await _enterReason("Approval note");

  if (reason == null) return;

  try {
    await _assignmentProvider.approve(
      assignment.assignmentId!,
      reason,
    );

    if (!mounted) return;

    await _refresh();

    MessageHelper.showSuccess(
      context,
      "Application approved successfully.",
    );
  } catch (e) {
    if (!mounted) return;

    MessageHelper.showError(
      context,
      e.toString().replaceFirst("Exception: ", ""),
    );
  }
}

  Future<void> _rejectAssignment(
    VolunteerAssignment assignment,
  ) async {
    final reason =
        await _enterReason("Rejection reason");

    if (reason == null) return;

    await _assignmentProvider.reject(
      assignment.assignmentId!,
      reason,
    );

    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Volunteer Activity Details",
      showBackButton: true,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildActivityCard(),
                  const SizedBox(height: 20),
                  _buildAssignmentsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildActivityCard() {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _activity?.title ?? "",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(_activity?.description ?? ""),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  DataRow _row(VolunteerAssignment a) {
  final color = getAssignmentStatusColor(a.status);

  return DataRow(
    cells: [
      DataCell(
        Text(
          a.userName ?? "",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      DataCell(
        Text(
          a.email ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      DataCell(Text(a.phoneNumber ?? "")),

      DataCell(
        Text(
          formatDate(a.appliedAt),
          style: const TextStyle(color: Colors.grey),
        ),
      ),

    
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            getAssignmentStatusText(a.status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),

      DataCell(
        Tooltip(
          message: a.adminResponseReason ?? "-",
          child: SizedBox(
            width: 260,
            child: Text(
              a.adminResponseReason ?? "-",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),

      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("${a.hoursWorked ?? 0}h"),
        ),
      ),

      DataCell(
        Row(
          children: [
            if (a.status == 0)
              IconButton(
                tooltip: "Approve",
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () => _approveAssignment(a),
              ),
            if (a.status == 0)
              IconButton(
                tooltip: "Reject",
                icon: const Icon(Icons.cancel_outlined),
                color: Colors.red,
                onPressed: () => _rejectAssignment(a),
              ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildAssignmentsCard() {
  if (_activity!.assignments.isEmpty) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text("No applications yet"),
        ),
      ),
    );
  }

  return Card(
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟣 HEADER
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "Volunteer Applications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 📊 TABLE
          SizedBox(
            height: 450,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable2(
                columnSpacing: 12,
                minWidth: 1000,
                headingRowHeight: 48,
                dataRowHeight: 56,
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey.shade100,
                ),
                columns: const [
                  DataColumn2(label: Text("Volunteer")),
                  DataColumn2(label: Text("Email")),
                  DataColumn2(label: Text("Phone")),
                  DataColumn2(label: Text("Applied")),
                  DataColumn2(label: Text("Status")),
                  DataColumn2(label: Text("Admin Response")),
                  DataColumn2(label: Text("Hours")),
                  DataColumn2(label: Text("Actions")),
                ],
                rows: _activity!.assignments.map(_row).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}