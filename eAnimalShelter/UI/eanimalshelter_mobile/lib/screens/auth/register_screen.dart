import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/register_request.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final _firstNameController =
      TextEditingController();

  final _lastNameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  final _phoneController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  bool _loading = false;

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String?_addressError;
  String? _phoneError;

  int _selectedRoleId = 3; // Client

  Future<void> register() async {
  setState(() {
    _firstNameError = null;
    _lastNameError = null;
    _emailError = null;
    _usernameError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _addressError = null;
    _phoneError = null;
  });

  bool hasError = false;

  if (_firstNameController.text.trim().isEmpty) {
    _firstNameError = "First name is required";
    hasError = true;
  } else if (_firstNameController.text.trim().length < 2) {
    _firstNameError =
        "First name must contain at least 2 characters";
    hasError = true;
  }

  if (_lastNameController.text.trim().isEmpty) {
    _lastNameError = "Last name is required";
    hasError = true;
  } else if (_lastNameController.text.trim().length < 2) {
    _lastNameError =
        "Last name must contain at least 2 characters";
    hasError = true;
  }

  if (_emailController.text.trim().isEmpty) {
    _emailError = "Email is required";
    hasError = true;
  } else if (!RegExp(
    r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
  ).hasMatch(_emailController.text.trim())) {
    _emailError = "Please enter a valid email";
    hasError = true;
  }

  if (_usernameController.text.trim().isEmpty) {
    _usernameError = "Username is required";
    hasError = true;
  } else if (_usernameController.text.trim().length < 3) {
    _usernameError =
        "Username must contain at least 3 characters";
    hasError = true;
  }

  if (_phoneController.text.trim().isNotEmpty &&
      !RegExp(r'^[0-9+\-\s]{6,20}$')
          .hasMatch(_phoneController.text.trim())) {
    _phoneError = "Invalid phone number";
    hasError = true;
  }

  if (_addressController.text.trim().isEmpty) {
    _addressError = "Address is required";
    hasError = true;
  } else if (_addressController.text.trim().length < 5) {
    _addressError =
        "Address must contain at least 5 characters";
    hasError = true;
  }

  if (_passwordController.text.isEmpty) {
    _passwordError = "Password is required";
    hasError = true;
  } else if (_passwordController.text.length < 8) {
    _passwordError =
        "Password must contain at least 8 characters";
    hasError = true;
  }

  if (_confirmPasswordController.text.isEmpty) {
    _confirmPasswordError =
        "Please confirm your password";
    hasError = true;
  } else if (_passwordController.text !=
      _confirmPasswordController.text) {
    _confirmPasswordError =
        "Passwords do not match";
    hasError = true;
  }

  if (hasError) {
    setState(() {});
    return;
  }

  try {
    setState(() {
      _loading = true;
    });

    await context
        .read<AuthProvider>()
        .register(
          RegisterRequest(
            firstName:
                _firstNameController.text.trim(),
            lastName:
                _lastNameController.text.trim(),
            email:
                _emailController.text.trim(),
            username:
                _usernameController.text.trim(),
            password:
                _passwordController.text,
            phoneNumber:
                _phoneController.text.trim(),
            address:
                _addressController.text.trim(),
            roleId:
                _selectedRoleId,
          ),
        );

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text("Success"),
          ],
        ),
        content: const Text(
          "Your account has been created successfully. You can now log in.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);
  } catch (e) {
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
  } finally {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

 Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  String? errorText,
}) {
  return Padding(
    padding:
        const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        errorText: errorText,
        filled: true,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required int value,
  }) {
    final selected =
        _selectedRoleId == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRoleId = value;
          });
        },
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? Colors.teal.withValues(
                    alpha: 0.15,
                  )
                : Colors.white,
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? Colors.teal
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.teal
                    : Colors.grey,
                size: 34,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  color: selected
                      ? Colors.teal
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,
      appBar: AppBar(
        title:
            const Text("Create Account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.pets,
                    color: Colors.teal,
                    size: 70,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Join eAnimalShelter",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 30),

                  _buildTextField(
                    controller:
                        _firstNameController,
                    label: "First Name",
                    icon: Icons.person,
                    errorText: _firstNameError,
                  ),

                  _buildTextField(
                    controller:
                        _lastNameController,
                    label: "Last Name",
                    icon: Icons.person_outline,
                     errorText: _lastNameError,
                  ),

                  _buildTextField(
                    controller:
                        _emailController,
                    label: "Email",
                    icon: Icons.email,
                    keyboardType:
                        TextInputType.emailAddress,
                   errorText: _emailError,
                  ),

                  _buildTextField(
                    controller:
                        _usernameController,
                    label: "Username",
                    icon:
                        Icons.account_circle,
                     errorText: _usernameError,
                  ),

                  _buildTextField(
                    controller:
                        _phoneController,
                    label: "Phone Number",
                    icon: Icons.phone,
                    keyboardType:
                        TextInputType.phone,
                    errorText: _phoneError,
                    
                  ),

                  _buildTextField(
                    controller:
                        _addressController,
                    label: "Address",
                    icon:
                        Icons.location_on,
                    errorText: _addressError
             ),

                  _buildTextField(
                    controller:
                        _passwordController,
                    label: "Password",
                    icon: Icons.lock,
                     errorText: _passwordError,
                    obscureText:
                        _hidePassword,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword =
                              !_hidePassword;
                        });
                      },
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility
                            : Icons
                                .visibility_off,
                      ),
                    ),
                  ),

                  _buildTextField(
                    controller:
                        _confirmPasswordController,
                    label:
                        "Confirm Password",
                    icon:
                        Icons.lock_outline,
                     errorText: _confirmPasswordError,
                    obscureText:
                        _hideConfirmPassword,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword =
                              !_hideConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility
                            : Icons
                                .visibility_off,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      "Register as",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildRoleCard(
                        title: "Client",
                        icon:
                            Icons.favorite,
                        value: 3,
                      ),
                      const SizedBox(
                          width: 12),
                      _buildRoleCard(
                        title:
                            "Volunteer",
                        icon:
                            Icons.volunteer_activism,
                        value: 2,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed:
                          _loading
                              ? null
                              : register,
                      style:
                          ElevatedButton.styleFrom(
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "CREATE ACCOUNT",
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}