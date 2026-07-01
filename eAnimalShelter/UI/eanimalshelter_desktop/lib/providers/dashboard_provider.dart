import 'dart:convert';

import 'package:http/http.dart'
    as http;

import '../models/dashboard.dart';
import 'auth_provider.dart';

class DashboardProvider {
  final String _baseUrl =
      const String.fromEnvironment(
    "baseUrl",
    defaultValue:
        "http://localhost:5036/",
  );

  Future<Dashboard> getStats()
      async {
    var response = await http.get(
      Uri.parse(
        "${_baseUrl}Dashboard",
      ),
      headers: {
        "Authorization":
            "Bearer ${AuthProvider.accessToken}",
        "Content-Type":
            "application/json",
      },
    );

    var data =
        jsonDecode(response.body);

    return Dashboard.fromJson(data);
  }
}