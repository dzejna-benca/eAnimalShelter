import 'package:flutter/material.dart';

class NavigationUtils {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?> pushAndRemoveAll<T>(Widget page) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return Future.value(null);
    }

    return navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static Future<T?> pushReplacement<T>(Widget page) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return Future.value(null);
    }

    return navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<bool> showSessionExpiredDialog() async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return false;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Session expired"),
          content:
              const Text("Please log in again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
