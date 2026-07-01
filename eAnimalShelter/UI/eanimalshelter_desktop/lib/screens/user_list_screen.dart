import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../dialogs/user_edit_dialog.dart';
import '../dialogs/user_insert_dialog.dart';
import '../models/role.dart';
import '../models/search_objects/user_search_object.dart';
import '../models/user.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/master_screen.dart';
import 'user_details_screen.dart';
import '../utils/message_helper.dart';
import '../utils/dialog_helper.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserProvider _userProvider;
  late RoleProvider _roleProvider;

  final TextEditingController _searchController = TextEditingController();

  List<User> _users = [];
  List<Role> _roles = [];

  String? _selectedRole;
  bool? _selectedStatus;

  bool _loading = false;

  int _page = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      _userProvider = context.read<UserProvider>();
      _roleProvider = context.read<RoleProvider>();

      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadRoles(),
      _loadUsers(),
    ]);
  }

  Future<void> _loadRoles() async {
    try {
      var result = await _roleProvider.get();

      if (!mounted) return;

      setState(() {
        _roles = result.items;
      });
    } catch (e) {

      MessageHelper.showError(
        context,
        e.toString(),
      );
    }
    }
  

  Future<void> _loadUsers() async {
    try {
      setState(() {
        _loading = true;
      });

      var result = await _userProvider.get(
        filter: UserSearchObject(
          fullName: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text,
          role: _selectedRole,
          isActive: _selectedStatus,
          page: _page,
          pageSize: _pageSize,
        ).toJson(),
      );

      if (!mounted) return;

      setState(() {
        _users = result.items;
        _totalCount = result.totalCount ?? 0;
        _loading = false;
      });
    } catch (e) {
      MessageHelper.showError(
    context,
    e.toString(),
  );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
  Future<void> _toggleStatus(User user) async {
  try {
    await _userProvider.update(
      user.userId!,
      {
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
        "roleId": user.roleId,
        "isActive": !(user.isActive ?? true),
      },
    );

    _loadUsers();

    if (!mounted) return;

    MessageHelper.showSuccess(
    context,
    user.isActive == true
        ? "User successfully deactivated."
        : "User successfully activated.",
  );
  } catch (e) {
     MessageHelper.showError(
    context,
    e.toString(),
  );
  }
}
  Future<void> _confirmToggleStatus(User user) async {
    final confirmed =
        await DialogHelper.confirmAction(
      context,
      title: user.isActive == true
          ? "Deactivate User"
          : "Activate User",
      message: user.isActive == true
          ? "Are you sure you want to deactivate ${user.firstName} ${user.lastName}?"
          : "Are you sure you want to activate ${user.firstName} ${user.lastName}?",
      confirmText:
          user.isActive == true
              ? "Deactivate"
              : "Activate",
      isDestructive:
          user.isActive == true,
    );

    if (confirmed) {
      await _toggleStatus(user);
    }
  }

  int get _totalPages {
    if (_totalCount == 0) return 1;
    return (_totalCount / _pageSize).ceil();
  }

  void _applySearch() {
    setState(() {
      _page = 1;
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "User Management",
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

  // ---------------- FILTERS ----------------
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
                  hintText: "Search user...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _applySearch(),
              ),
            ),

            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String?>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text("All Roles")),
                  ..._roles.map((r) => DropdownMenuItem(
                        value: r.name,
                        child: Text(r.name ?? ""),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                    _page = 1;
                  });
                  _loadUsers();
                },
              ),
            ),

            SizedBox(
              width: 180,
              child: DropdownButtonFormField<bool?>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("All")),
                  DropdownMenuItem(value: true, child: Text("Active")),
                  DropdownMenuItem(value: false, child: Text("Inactive")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                    _page = 1;
                  });
                  _loadUsers();
                },
              ),
            ),

            ElevatedButton.icon(
              onPressed: _applySearch,
              icon: const Icon(Icons.search),
              label: const Text("Search"),
            ),

            ElevatedButton.icon(
              onPressed: () async {
                var result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const UserInsertDialog(),
                );

                if (result == true) {
                MessageHelper.showSuccess(
                  context,
                  "User successfully created.",
                );

                _loadUsers();
              }
              },
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TABLE ----------------
  Widget _buildTable() {
    return DataTable2(
      columnSpacing: 40,
      horizontalMargin: 30,
      minWidth: 900,
      columns: const [
        DataColumn2(label: Text("Name")),
        DataColumn2(label: Text("Email")),
        DataColumn2(label: Text("Role")),
        DataColumn2(label: Text("Status")),
        DataColumn2(label: Text("Actions")),
      ],
      rows: _users.map((user) {
        return DataRow(
          cells: [
            DataCell(Text("${user.firstName ?? ""} ${user.lastName ?? ""}")),
            DataCell(
              SizedBox(
                width: 220,
                child: Text(
                  user.email ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
            DataCell(Text(user.role ?? "")),

            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (user.isActive == true
                          ? Colors.green
                          : Colors.red)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.isActive == true ? "Active" : "Inactive",
                  style: TextStyle(
                    color: user.isActive == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            DataCell(
              Row(
                children: [
                  IconButton(
                    tooltip: "Edit",
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      var result = await showDialog<bool>(
                        context: context,
                        builder: (_) => UserEditDialog(user: user),
                      );

                      if (result == true) {
                      MessageHelper.showSuccess(
                        context,
                        "User information successfully updated.",
                      );

                      _loadUsers();
                    }
                    },
                  ),

                  IconButton(
                    tooltip: user.isActive == true ? "Deactivate" : "Activate",
                    icon: Icon(
                      user.isActive == true ? Icons.block : Icons.check,
                      color: user.isActive == true ? Colors.red : Colors.green,
                    ),
                    onPressed: () => _confirmToggleStatus(user),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "details") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailsScreen(
                              userId: user.userId!,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "details",
                        child: Text("Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ---------------- PAGINATION ----------------
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _page > 1
              ? () {
                  setState(() => _page--);
                  _loadUsers();
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
                  _loadUsers();
                }
              : null,
          child: const Text("Next"),
        ),
      ],
    );
  }
}