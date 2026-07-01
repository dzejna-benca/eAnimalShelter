import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/adoption_request.dart';
import 'base_provider.dart';

class AdoptionRequestProvider
    extends BaseProvider<AdoptionRequest> {

  AdoptionRequestProvider()
      : super("AdoptionRequest");

  Future<void> approve(
    int id,
    String? comment,
  ) async {
    var response = await http.post(
      Uri.parse(
  "${BaseProvider.baseUrl}AdoptionRequest/$id/approve",
    ),
      headers: createHeaders(),
      body: jsonEncode(comment),
    );

    if (!isValidResponse(response)) {
      throw Exception(
        "Approve failed.",
      );
    }
  }
  Future<void> reject(
    int id,
    String? comment,
  ) async {
    var response = await http.post(
      Uri.parse(
    "${BaseProvider.baseUrl}AdoptionRequest/$id/reject",
  ),
      headers: createHeaders(),
      body: jsonEncode(comment),
    );

    if (!isValidResponse(response)) {
      throw Exception(
        "Reject failed.",
      );
    }
  }

  
  @override
  AdoptionRequest fromJson(data) {
    return AdoptionRequest.fromJson(data);
  }
}