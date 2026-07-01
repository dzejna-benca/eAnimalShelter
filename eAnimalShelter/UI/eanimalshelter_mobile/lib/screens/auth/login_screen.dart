import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../client/client_home_screen.dart';
import '../volunteer/volunteer_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  bool _loading = false;
  bool _hidePassword = true;

  String? _errorMessage;

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    try {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      final authProvider =
          context.read<AuthProvider>();

      final role =
          await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (role == "Client") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const ClientHomeScreen(),
          ),
        );
      } else if (role ==
          "Volunteer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const VolunteerHomeScreen(),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              "This account cannot use the mobile application.";
        });
      }
    } catch (_) {
      setState(() {
        _errorMessage =
            "Incorrect username or password";
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _clearServerError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode
                    .onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),

                const Icon(
                  Icons.pets,
                  size: 90,
                  color: Colors.teal,
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  "eAnimalShelter",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "Helping animals find a home",
                ),

                const SizedBox(
                  height: 40,
                ),

                TextFormField(
                  controller:
                      _usernameController,
                  onChanged: (_) {
                    _clearServerError();
                  },
                  textInputAction:
                      TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return "Username is required";
                    }

                    if (value
                            .trim()
                            .length <
                        3) {
                      return "Username must contain at least 3 characters";
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Username",
                    prefixIcon:
                        Icon(
                      Icons.person,
                    ),
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  controller:
                      _passwordController,
                  onChanged: (_) {
                    _clearServerError();
                  },
                  obscureText:
                      _hidePassword,
                  textInputAction:
                      TextInputAction.done,
                  onFieldSubmitted:
                      (_) => login(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Password is required";
                    }

                    return null;
                  },
                  decoration:
                      InputDecoration(
                    labelText:
                        "Password",
                    prefixIcon:
                        const Icon(
                      Icons.lock,
                    ),
                    border:
                        const OutlineInputBorder(),
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
                            ? Icons
                                .visibility
                            : Icons
                                .visibility_off,
                      ),
                    ),
                  ),
                ),

                if (_errorMessage != null)
                  Padding(
                    padding:
                        const EdgeInsets
                            .only(
                      top: 12,
                    ),
                    child: Text(
                      _errorMessage!,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),

                const SizedBox(
                  height: 24,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 55,
                  child:
                      ElevatedButton(
                    onPressed:
                        _loading
                            ? null
                            : login,
                    child:
                        _loading
                            ? const SizedBox(
                                height:
                                    24,
                                width:
                                    24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2.5,
                                ),
                              )
                            : const Text(
                                "LOGIN",
                              ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create account",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}