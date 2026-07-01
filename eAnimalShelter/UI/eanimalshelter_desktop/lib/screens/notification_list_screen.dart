import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/notification_add_dialog.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';
import '../widgets/master_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;

  final TextEditingController _searchController =
      TextEditingController();

  List<NotificationModel> _notifications = [];

  bool _loading = false;
  bool _initialized = false;

  int? _selectedType;
  bool? _selectedIsRead;
  String? _selectedSortBy;

  int _page = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      _notificationProvider =
          context.read<NotificationProvider>();

      _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() => _loading = true);

      var result =
          await _notificationProvider.get(
        filter: {
          "fts":
              _searchController.text.trim().isEmpty
                  ? null
                  : _searchController.text.trim(),
          "type": _selectedType,
          "isRead": _selectedIsRead,
          "sortBy": _selectedSortBy,
          "page": _page,
          "pageSize": _pageSize,
          "includeTotalCount": true,
        },
      );

      if (!mounted) return;

      setState(() {
        _notifications = result.items;
        _totalCount = result.totalCount ?? 0;
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _applySearch() {
    setState(() => _page = 1);
    _loadNotifications();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  int get _totalPages {
    if (_totalCount == 0) return 1;
    return (_totalCount / _pageSize).ceil();
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";

    return "${date.day.toString().padLeft(2, '0')}."
        "${date.month.toString().padLeft(2, '0')}."
        "${date.year}";
  }

  String getTypeText(int? type) {
    switch (type) {
      case 0:
        return "Adoption";
      case 1:
        return "Volunteer";
      case 2:
        return "Donation";
      case 3:
        return "Announcement";
      case 4:
        return "System";
      default:
        return "-";
    }
  }

  Color getTypeColor(int? type) {
    switch (type) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String getRecipient(
    NotificationModel notification,
  ) {
    if (notification.userName != null &&
        notification.userName!.isNotEmpty) {
      return notification.userName!;
    }

    if (notification.targetRoleName != null &&
        notification.targetRoleName!.isNotEmpty) {
      return notification.targetRoleName!;
    }

    return "-";
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Notifications",
      child: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: _loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
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
          crossAxisAlignment:
              WrapCrossAlignment.end,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration:
                    const InputDecoration(
                  hintText:
                      "Search notifications...",
                  prefixIcon:
                      Icon(Icons.search),
                  border:
                      OutlineInputBorder(),
                ),
                onSubmitted: (_) =>
                    _applySearch(),
              ),
            ),

            SizedBox(
              width: 180,
              child:
                  DropdownButtonFormField<int?>(
                value: _selectedType,
                decoration:
                    const InputDecoration(
                  labelText: "Type",
                  border:
                      OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text("All"),
                  ),
                  DropdownMenuItem(
                    value: 0,
                    child: Text("Adoption"),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Volunteer"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Donation"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text(
                        "Announcement"),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text("System"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _page = 1;
                  });

                  _loadNotifications();
                },
              ),
            ),

            SizedBox(
              width: 180,
              child:
                  DropdownButtonFormField<bool?>(
                value: _selectedIsRead,
                decoration:
                    const InputDecoration(
                  labelText: "Status",
                  border:
                      OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text("All"),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text("Unread"),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Text("Read"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedIsRead = value;
                    _page = 1;
                  });

                  _loadNotifications();
                },
              ),
            ),

            SizedBox(
              width: 180,
              child:
                  DropdownButtonFormField<String?>(
                value: _selectedSortBy,
                decoration:
                    const InputDecoration(
                  labelText: "Sort By",
                  border:
                      OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "date_desc",
                    child: Text(
                        "Newest First"),
                  ),
                  DropdownMenuItem(
                    value: "date",
                    child: Text(
                        "Oldest First"),
                  ),
                  DropdownMenuItem(
                    value: "title",
                    child: Text("Title"),
                  ),
                  DropdownMenuItem(
                    value: "type",
                    child: Text("Type"),
                  ),
                  DropdownMenuItem(
                    value: "status",
                    child: Text("Status"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSortBy = value;
                    _page = 1;
                  });

                  _loadNotifications();
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
                  _selectedType = null;
                  _selectedIsRead = null;
                  _selectedSortBy = null;
                  _page = 1;
                });

                _loadNotifications();
              },
              icon: const Icon(Icons.clear),
              label: const Text("Clear"),
            ),

            ElevatedButton.icon(
              onPressed: () async {
                var refresh =
                    await showDialog<bool>(
                  context: context,
                  builder: (_) =>
                      const NotificationAddDialog(),
                );

                if (refresh == true) {
                  _loadNotifications();
                }
              },
              icon: const Icon(Icons.add),
              label:
                  const Text("Create Notification"),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildTable() {
    return DataTable2(
      dataRowHeight: 60,
      headingRowHeight: 55,
      columnSpacing: 20,
      horizontalMargin: 16,
      minWidth: 1100,
      columns: const [
        DataColumn2(
          label: Text("Title"),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text("Recipient"),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text("Type"),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text("Date"),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text("Status"),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text("Actions"),
          size: ColumnSize.S,
        ),
      ],
      rows: _notifications.map((notification) {
        return DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (notification.isRead == false) {
                return Colors.blue.withOpacity(0.03);
              }
              return null;
            },
          ),
          cells: [
            DataCell(
              Text(
                notification.title ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            DataCell(
              Text(
                getRecipient(notification),
              ),
            ),

            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: getTypeColor(
                    notification.type,
                  ).withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  getTypeText(
                    notification.type,
                  ),
                  style: TextStyle(
                    color: getTypeColor(
                      notification.type,
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            DataCell(
              Text(
                formatDate(
                  notification.dateSent,
                ),
              ),
            ),

            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: notification.isRead == true
                      ? Colors.green.withOpacity(
                          0.12,
                        )
                      : Colors.orange.withOpacity(
                          0.12,
                        ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  notification.isRead == true
                      ? "Read"
                      : "Unread",
                  style: TextStyle(
                    color:
                        notification.isRead == true
                            ? Colors.green
                            : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            DataCell(
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                ),
                onSelected: (value) async {
                  if (value == "delete") {
                    var confirm =
                        await showDialog<bool>(
                      context: context,
                      builder: (_) =>
                          AlertDialog(
                        title: const Text(
                          "Delete Notification",
                        ),
                        content: const Text(
                          "Are you sure you want to delete this notification?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                              context,
                              false,
                            ),
                            child:
                                const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(
                              context,
                              true,
                            ),
                            child:
                                const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        await _notificationProvider
                            .delete(
                          notification
                              .notificationId!,
                        );

                        _loadNotifications();

                        if (mounted) {
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Notification deleted successfully",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        _showError(
                          e.toString(),
                        );
                      }
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
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
      mainAxisAlignment:
          MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _page > 1
              ? () {
                  setState(() => _page--);
                  _loadNotifications();
                }
              : null,
          child: const Text("Previous"),
        ),
        const SizedBox(width: 15),
        Text(
          "Page $_page of $_totalPages",
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: _page < _totalPages
              ? () {
                  setState(() => _page++);
                  _loadNotifications();
                }
              : null,
          child: const Text("Next"),
        ),
      ],
    );
  }
}