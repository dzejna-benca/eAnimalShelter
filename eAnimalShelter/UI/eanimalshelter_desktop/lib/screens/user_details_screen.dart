
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/master_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final int userId;

  const UserDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UserProvider _userProvider;

  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final result = await _userProvider.getById(widget.userId);

      if (!mounted) return;

      setState(() {
        _user = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "User Details",
      showBackButton: true,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildContent(),
              ),
            ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final fullName =
        "${_user?.firstName ?? ""} ${_user?.lastName ?? ""}".trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: const Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(_user?.role ?? "-"),
          ),
          const SizedBox(height: 8),
          _statusChip(),
        ],
      ),
    );
  }

  Widget _statusChip() {
    final isActive = _user?.isActive == true;

    return Chip(
      label: Text(isActive ? "Active" : "Inactive"),
      backgroundColor:
          isActive ? Colors.green.shade100 : Colors.red.shade100,
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _infoTile(Icons.person_outline, "Username", _user?.username),
            _infoTile(Icons.email_outlined, "Email", _user?.email),
            _infoTile(Icons.phone_outlined, "Phone Number", _user?.phoneNumber),
            _infoTile(Icons.location_on_outlined, "Address", _user?.address),
            _infoTile(Icons.badge_outlined, "Role", _user?.role),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value ?? "-"),
    );
  }
}

