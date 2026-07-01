import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/role.dart';
import '../models/user.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';
import '../utils/validators.dart';
import '../utils/message_helper.dart';

class UserEditDialog extends StatefulWidget {
  final User user;

  const UserEditDialog({
    super.key,
    required this.user,
  });

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  int? _selectedRoleId;
  bool _loading = false;

  List<Role> _roles = [];

  late UserProvider _userProvider;
  late RoleProvider _roleProvider;

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _roleProvider = context.read<RoleProvider>();

    _firstNameController =
        TextEditingController(text: widget.user.firstName);

    _lastNameController =
        TextEditingController(text: widget.user.lastName);

    _emailController =
        TextEditingController(text: widget.user.email);

    _phoneController =
        TextEditingController(text: widget.user.phoneNumber);

    _addressController =
        TextEditingController(text: widget.user.address);

    _selectedRoleId = widget.user.roleId;

    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final result = await _roleProvider.get();
      setState(() => _roles = result.items);
    } catch (e) {
      if (!mounted) return;
       MessageHelper.showError(
      context,
      e.toString(),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _loading = true);

      await _userProvider.update(
        widget.user.userId!,
        {
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "email": _emailController.text,
          "phoneNumber": _phoneController.text,
          "address": _addressController.text,
          "roleId": _selectedRoleId,
          "isActive": widget.user.isActive,
        },
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
       MessageHelper.showError(
      context,
      e.toString(),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 750,
        ),
        child: Column(
          children: [
            _header(),
            Expanded(child: _form()),
            _actions(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    final fullName =
        "${widget.user.firstName ?? ""} ${widget.user.lastName ?? ""}".trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit User",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  fullName,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  Widget _form() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _section("Personal Information"),
            _field(_firstNameController, "First Name",validator:AppValidators.firstName),
            const SizedBox(height: 12),
            _field(_lastNameController, "Last Name",validator:AppValidators.lastName),

            const SizedBox(height: 20),
            _section("Account"),
            _field(_emailController, "Email",validator:AppValidators.email),

            const SizedBox(height: 20),
            _section("Contact"),
            _field(_phoneController, "Phone Number", required:false,validator:AppValidators.phone),
            const SizedBox(height: 12),
            _field(_addressController, "Address",required: false,validator:AppValidators.address),

            const SizedBox(height: 20),
            _section("Role"),

            DropdownButtonFormField<int>(
              value: _selectedRoleId,
              decoration: _input("Role"),
              validator:AppValidators.role,
              items: _roles
                  .map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.name ?? ""),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRoleId = v),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ACTIONS =================
  Widget _actions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _loading ? null : _save,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Save Changes"),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _section(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      decoration: _input(label),
      validator: validator,
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}