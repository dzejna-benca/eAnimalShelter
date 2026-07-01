import 'package:data_table_2/data_table_2.dart';
import 'package:eanimalshelter_desktop/dialogs/volunteer_activity_add_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/search_objects/volunteer_activity_search_object.dart';
import '../models/volunteer_activity.dart';
import '../providers/location_provider.dart';
import '../providers/volunteer_activity_provider.dart';
import '../widgets/master_screen.dart';
import 'volunteer_activity_details_screen.dart';
import '../utils/message_helper.dart';
import '../utils/dialog_helper.dart';

class VolunteerActivityListScreen extends StatefulWidget {
  const VolunteerActivityListScreen({super.key});

  @override
  State<VolunteerActivityListScreen> createState() =>
      _VolunteerActivityListScreenState();
}

class _VolunteerActivityListScreenState
    extends State<VolunteerActivityListScreen> {
  late VolunteerActivityProvider _activityProvider;
  late LocationProvider _locationProvider;

  final TextEditingController _searchController = TextEditingController();

  List<VolunteerActivity> _activities = [];
  List<Location> _locations = [];

  bool _loading = false;
  bool _initialized = false;

  int? _selectedStatus;
  String? _selectedSortBy;
  int? _selectedLocationId;

  int _page = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day.toString().padLeft(2, '0')}."
        "${date.month.toString().padLeft(2, '0')}."
        "${date.year}";
  }

 Future<void> _initialize() async {
  await _loadLocations();
  await _loadActivities();
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_initialized) {
    _initialized = true;

    _activityProvider =
        context.read<VolunteerActivityProvider>();

    _locationProvider =
        context.read<LocationProvider>();

    _initialize();
  }
}

  Future<void> _loadActivities() async {
    try {
      setState(() => _loading = true);

      var result = await _activityProvider.get(
      filter: VolunteerActivitySearchObject(
        title: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        locationId: _selectedLocationId,
        status: _selectedStatus,
        sortBy: _selectedSortBy,
        page: _page,
        pageSize: _pageSize,
      ).toJson(),
    );

      if (!mounted) return;

      setState(() {
        _activities = result.items;
        _totalCount = result.totalCount ?? 0;
      });
    } catch (e) {
      MessageHelper.showError(
      context,
      e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String getStatusText(int? status) {
    switch (status) {
      case 0:
        return "Active";
      case 1:
        return "Completed";
      case 2:
        return "Cancelled";
      default:
        return "-";
    }
  }
  Future<void> _loadLocations() async {
    try {
      var result = await _locationProvider.get();

      if (!mounted) return;

      setState(() {
        _locations = result.items;
      });
    } catch (e) {
      MessageHelper.showError(
      context,
      e.toString());
    }
  }
  Color getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _applySearch() {
    setState(() => _page = 1);
    _loadActivities();
  }

  int get _totalPages {
    if (_totalCount == 0) return 1;
    return (_totalCount / _pageSize).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Volunteer Activities",
      child: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildTable(),
            ),
          ),
          const SizedBox(height: 15),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search volunteer activity...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _applySearch(),
              ),
            ),

            SizedBox(
              width: 250,
              child: DropdownButtonFormField<int?>(
                value: _selectedLocationId,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text("All Locations"),
                  ),
                  ..._locations.map(
                    (location) => DropdownMenuItem<int?>(
                      value: location.locationId,
                      child: Text(location.name ?? ""),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLocationId = value;
                    _page = 1;
                  });

                  _loadActivities();
                },
              ),
            ),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<int?>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("All")),
                  DropdownMenuItem(value: 0, child: Text("Active")),
                  DropdownMenuItem(value: 1, child: Text("Completed")),
                  DropdownMenuItem(value: 2, child: Text("Cancelled")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                    _page = 1;
                  });
                  _loadActivities();
                },
              ),
            ),

            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String?>(
                value: _selectedSortBy,
                decoration: const InputDecoration(
                  labelText: "Sort By",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "title", child: Text("Title")),
                  DropdownMenuItem(value: "date", child: Text("Date")),
                  DropdownMenuItem(value: "status", child: Text("Status")),
                  DropdownMenuItem(value: "location", child: Text("Location")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSortBy = value;
                    _page = 1;
                  });
                  _loadActivities();
                },
              ),
            ),

            ElevatedButton.icon(
                onPressed: _applySearch,
                icon: const Icon(Icons.search),
                label: const Text("Search"),
              ),
              OutlinedButton.icon(
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _selectedLocationId = null;
                              _selectedStatus = null;
                              _selectedSortBy = null;
                              _page = 1;
                            });

                            _loadActivities();
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text("Clear"),
                        ),
                         ElevatedButton.icon(
                            onPressed: () async {
                              var refresh = await showDialog(
                              context: context,
                              builder: (context) =>
                                  const VolunteerActivityAddEditDialog(),
                            );

                              if (refresh == true) _loadActivities();
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Activity"),
                          ),
                          
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return DataTable2(
      dataRowHeight: 50,
      headingRowHeight: 50,
      columnSpacing: 20,
      horizontalMargin: 16,
      minWidth: 1000,
      columns: const [
        DataColumn2(label: Text("Title"), size: ColumnSize.L),
        DataColumn2(label: Text("Location"), size: ColumnSize.M),
        DataColumn2(label: Text("Date"), size: ColumnSize.M),
        DataColumn2(label: Text("Volunteers"), size: ColumnSize.M),
        DataColumn2(label: Text("Applications"), size: ColumnSize.M),
        DataColumn2(label: Text("Status"), size: ColumnSize.M),
        DataColumn2(label: Text("Actions"), size: ColumnSize.S),
      ],
      rows: _activities.map((activity) {
        return DataRow(
          cells: [
            DataCell(Text(activity.title ?? "")),
            DataCell(Text(activity.locationName ?? "")),
            DataCell(Text(formatDate(activity.startDateTime))),
            DataCell(
              Text(
                "${activity.currentVolunteers ?? 0}/${activity.maxVolunteers ?? 0}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(
              Text(
                "${activity.applicationsCount ?? 0}",
                style: const TextStyle(fontWeight: FontWeight.w600,),),),
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      getStatusColor(activity.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusText(activity.status),
                  style: TextStyle(
                    color: getStatusColor(activity.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
             DataCell(
                                          PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              if (value == "details") {
                                                var refresh = await Navigator.push<bool>(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => VolunteerActivityDetailsScreen(
                                                      activityId: activity.activityId!,
                                                    ),
                                                  ),
                                                );

                                                if (refresh == true) {
                                                  await _loadActivities();
                                                }
                                              }
                                              if (!mounted) return;
                                              if (value == "edit") {
                                              var refresh = await showDialog<bool>(
                                                context: context,
                                                builder: (_) => VolunteerActivityAddEditDialog(
                                                  activity: activity,
                                                ),
                                              );
                                               if (!mounted) return;

                                              if (refresh == true) {
                                                _loadActivities();
                                              }
                                            }
                                            if (!mounted) return;
                                            if (value == "cancel") {
                                              final confirm =
                                                await DialogHelper.confirmAction(
                                              context,
                                              title: "Cancel Activity",
                                              message:
                                                  "Are you sure you want to cancel this activity?",
                                              confirmText: "Cancel Activity",
                                              isDestructive: true,
                                            );

                                              if (confirm == true) {
                                               await _activityProvider.cancelActivity(
                                                  activity.activityId,
                                                
                                                );

                                                if (!mounted) return;

                                                MessageHelper.showSuccess(
                                                  context,
                                                  "Volunteer activity cancelled successfully.",
                                                );
      

                                                await _loadActivities();
                                              }
                                            }
                                      
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(value: "details", child: Text("View Details")),
                                              if (activity.status == 0)
                                              const PopupMenuItem(value: "edit",child: Text("Edit")),
                                              if (activity.status == 0)
                                              const PopupMenuItem(
                                                value: "cancel",
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                        ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _page > 1
              ? () {
                  setState(() => _page--);
                  _loadActivities();
                }
              : null,
          child: const Text("Previous"),
        ),
        const SizedBox(width: 15),
        Text("Page $_page of $_totalPages"),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: _page < _totalPages
              ? () {
                  setState(() => _page++);
                  _loadActivities();
                }
              : null,
          child: const Text("Next"),
        ),
      ],
    );
  }
}