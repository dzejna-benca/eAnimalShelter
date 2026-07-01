import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/role.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';
import '../utils/validators.dart';
import '../utils/message_helper.dart';

class UserInsertDialog extends StatefulWidget {
  const UserInsertDialog({super.key});

  @override
  State<UserInsertDialog> createState() => _UserInsertDialogState();
}

class _UserInsertDialogState extends State<UserInsertDialog> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  List<Role> _roles = [];
  int? _selectedRoleId;

  bool _loading = false;

  late RoleProvider _roleProvider;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _roleProvider = context.read<RoleProvider>();
    _userProvider = context.read<UserProvider>();
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

      await _userProvider.insert({
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "username": _usernameController.text,
        "password": _passwordController.text,
        "phoneNumber": _phoneController.text,
        "address": _addressController.text,
        "isActive": true,
        "roleId": _selectedRoleId,
      });

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
          maxWidth: 600,
          maxHeight: 750,
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildForm()),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
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
            child: Icon(Icons.person_add),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Create New User",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Personal Information"),
            const SizedBox(height: 10),

            _field(_firstNameController, "First Name",validator:AppValidators.firstName),
            const SizedBox(height: 12),
            _field(_lastNameController, "Last Name",validator:AppValidators.lastName),

            const SizedBox(height: 20),
            _sectionTitle("Account"),
            const SizedBox(height: 10),

            _field(_emailController, "Email", validator:AppValidators.email),
            const SizedBox(height: 12),
            _field(_usernameController, "Username", validator:AppValidators.username),
            const SizedBox(height: 12),
            _field(_passwordController, "Password", obscure: true, validator:AppValidators.password),

            const SizedBox(height: 20),
            _sectionTitle("Contact"),
            const SizedBox(height: 10),

            _field(_phoneController, "Phone Number", required: false,validator:AppValidators.phone),
            const SizedBox(height: 12),
            _field(_addressController, "Address",validator:AppValidators.address),

            const SizedBox(height: 20),
            _sectionTitle("Role"),
            const SizedBox(height: 10),

            DropdownButtonFormField<int>(
              value: _selectedRoleId,
              decoration: _inputDecoration("Select Role"),
              validator: AppValidators.role,
              items: _roles
                  .map(
                    (role) => DropdownMenuItem<int>(
                      value: role.id,
                      child: Text(role.name ?? ""),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedRoleId = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= ACTIONS =================
  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Create User"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: _inputDecoration(label),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String label) {
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