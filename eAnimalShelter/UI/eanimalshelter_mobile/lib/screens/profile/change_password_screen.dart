import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_password_change_request.dart';
import '../../providers/profile_provider.dart';

class ChangePasswordScreen
    extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen>
      createState() =>
          _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final currentController =
      TextEditingController();

  final newController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool loading = false;

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  Future<void> save() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        "Confirm Password Change",
      ),
      content: const Text(
        "Are you sure you want to change your password?",
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, false),
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () =>
              Navigator.pop(context, true),
          child: const Text(
            "Change Password",
          ),
        ),
      ],
    ),
  );

  if (confirm != true) {
    return;
  }

  try {
    setState(() {
      loading = true;
    });

    await context
        .read<ProfileProvider>()
        .changePassword(
          UserPasswordChangeRequest(
            password:
                currentController.text,
            newPassword:
                newController.text,
            confirmNewPassword:
                confirmController.text,
          ),
        );

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        title: const Text(
          "Password Changed",
        ),
        content: const Text(
          "Your password has been changed successfully.",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
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
        loading = false;
      });
    }
  }
}

  InputDecoration decoration(
    String label,
    bool visible,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          visible
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: toggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isTablet = width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(
              isTablet ? 32 : 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Card(
                  elevation: 3,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.lock,
                            size: 60,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          const Text(
                            "Update Your Password",
                            style:
                                TextStyle(
                              fontSize:
                                  22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          TextFormField(
                            controller:
                                currentController,
                            obscureText:
                                !showCurrent,
                            decoration:
                                decoration(
                              "Current Password",
                              showCurrent,
                              () {
                                setState(() {
                                  showCurrent =
                                      !showCurrent;
                                });
                              },
                            ),
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .isEmpty) {
                                return "Current password is required.";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          TextFormField(
                            controller:
                                newController,
                            obscureText:
                                !showNew,
                            decoration:
                                decoration(
                              "New Password",
                              showNew,
                              () {
                                setState(() {
                                  showNew =
                                      !showNew;
                                });
                              },
                            ),
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .isEmpty) {
                                return "New password is required.";
                              }

                              if (value
                                      .length <
                                  6) {
                                return "Password must contain at least 6 characters.";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          TextFormField(
                            controller:
                                confirmController,
                            obscureText:
                                !showConfirm,
                            decoration:
                                decoration(
                              "Confirm New Password",
                              showConfirm,
                              () {
                                setState(() {
                                  showConfirm =
                                      !showConfirm;
                                });
                              },
                            ),
                            validator:
                                (value) {
                              if (value !=
                                  newController
                                      .text) {
                                return "Passwords do not match.";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          SizedBox(
                            width:
                                double.infinity,
                            height: 55,
                            child:
                                ElevatedButton.icon(
                              icon: const Icon(
                                Icons.save,
                              ),
                              onPressed:
                                  loading
                                      ? null
                                      : save,
                              label: const Text(
                                "Change Password",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}