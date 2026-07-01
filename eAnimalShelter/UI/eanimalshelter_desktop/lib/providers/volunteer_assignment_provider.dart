import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/volunteer_assignment.dart';
import 'base_provider.dart';

class VolunteerAssignmentProvider
    extends BaseProvider<VolunteerAssignment> {
  VolunteerAssignmentProvider()
      : super("VolunteerAssignment");

  @override
  VolunteerAssignment fromJson(data) {
    return VolunteerAssignment.fromJson(data);
  }

  Future<VolunteerAssignment> approve(
    int id,
    String reason,
  ) async {
    return await _executeAction(
      id,
      "approve",
      {
        "reason": reason,
      },
    );
  }

  Future<VolunteerAssignment> reject(
    int id,
    String reason,
  ) async {
    return await _executeAction(
      id,
      "reject",
      {
        "reason": reason,
      },
    );
  }

  Future<VolunteerAssignment> cancel(
    int id,
  ) async {
    return await _executeAction(
      id,
      "cancel",
    );
  }

  Future<VolunteerAssignment> complete(
    int id,
  ) async {
    return await _executeAction(
      id,
      "complete",
    );
  }

  Future<VolunteerAssignment> _executeAction(
    int id,
    String action, [
    Map<String, dynamic>? body,
  ]) async {
    var url =
        "${BaseProvider.baseUrl}$endpoint/$id/$action";

    var response = await http.post(
      Uri.parse(url),
      headers: createHeaders(),
      body: jsonEncode(body ?? {}),
    );

    if (isValidResponse(response)) {
      return fromJson(
        jsonDecode(response.body),
      );
    }

    var error = jsonDecode(response.body);

    throw Exception(
      error["message"] ??
          "Action failed",
    );
  }
}