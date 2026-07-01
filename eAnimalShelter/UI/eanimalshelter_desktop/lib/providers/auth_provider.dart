import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';

class UnauthorizedRoleException
    implements Exception {
  final String message;

  UnauthorizedRoleException(
    this.message,
  );

  @override
  String toString() => message;
}

class AuthProvider extends ChangeNotifier {
  static String? _accessToken;
  String? _refreshToken;

  static String? _fullName;

  static String get fullName =>
      _fullName ?? "Administrator";


  bool _isAuthenticated = false;

  static String? get accessToken => _accessToken;

  bool get isAuthenticated => _isAuthenticated;

  final String _baseUrl =
    "${AppConfig.apiUrl}Access";

  Future<void> login(
    String username,
    String password,
  ) async {
    final url = "$_baseUrl/Login";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final data = jsonDecode(response.body);

      final role = data["role"]?.toString();

      if (role != "Admin") {
        throw UnauthorizedRoleException(
          "This desktop application is intended for administrators only.",
        );
      }

      _accessToken = data["accessToken"];
      _refreshToken = data["refreshToken"];

      _fullName =
          "${data["firstName"] ?? ""} ${data["lastName"] ?? ""}"
              .trim();

      _isAuthenticated = true;

      notifyListeners();

      return;
    }

    // Login nije uspio
    _accessToken = null;
    _refreshToken = null;
    _fullName = null;
    _isAuthenticated = false;

    throw Exception("Incorrect username or password.");
  }
  void logout() {
    _accessToken = null;
    _refreshToken = null;
    _isAuthenticated = false;

    notifyListeners();
  }
}

