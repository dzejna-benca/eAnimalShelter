import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/client/client_home_screen.dart';
import '../screens/volunteer/volunteer_home_screen.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() =>
      _AppStartState();
}

class _AppStartState
    extends State<AppStart> {

  Widget? screen;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final auth =
        context.read<AuthProvider>();

    bool loggedIn =
        await auth.tryAutoLogin();

    if (!mounted) return;

    setState(() {
      if (!loggedIn) {
        screen = const LoginScreen();
      } else if (auth.role ==
          "Volunteer") {
        screen =
            const VolunteerHomeScreen();
      } else {
        screen =
            const ClientHomeScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (screen == null) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return screen!;
  }
}