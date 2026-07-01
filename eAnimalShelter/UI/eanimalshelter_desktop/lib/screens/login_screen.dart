import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

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

      await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const DashboardScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (e is UnauthorizedRoleException) {
          _errorMessage = e.message;
        } else {
          _errorMessage =
              "Incorrect username or password.";
        }
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          child: Container(
            width: 450,
            padding:
                const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              autovalidateMode:
                  AutovalidateMode
                      .onUserInteraction,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.teal,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    "eAnimal Shelter",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(
                    height: 30,
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
                          Icon(Icons.person),
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
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
                        icon: Icon(
                          _hidePassword
                              ? Icons
                                  .visibility
                              : Icons
                                  .visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword =
                                !_hidePassword;
                          });
                        },
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
                    height: 30,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,
                    child:
                        ElevatedButton(
                      onPressed:
                          _loading
                              ? null
                              : login,
                      child:
                          _loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}