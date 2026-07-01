import '../models/volunteer_activity.dart';
import 'base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/volunteer_activity_details.dart';

class VolunteerActivityProvider
    extends BaseProvider<VolunteerActivity> {
  VolunteerActivityProvider()
      : super("VolunteerActivity");
  
  Future<VolunteerActivityDetails>
      getDetails(int id) async {
    var url =
        "${BaseProvider.baseUrl}$endpoint/$id/details";

    var response = await http.get(
      Uri.parse(url),
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      var data =
          jsonDecode(response.body);

      return VolunteerActivityDetails
          .fromJson(data);
    }

    throw Exception(
      "Unable to load activity details.",
    );
  }
  Future<void> cancelActivity(int id) async {
    var url = "${BaseProvider.baseUrl}$endpoint/$id/cancel";

    var response = await http.post(
      Uri.parse(url),
      headers: createHeaders(),
    );

    if (!isValidResponse(response)) {
      throw Exception("Unable to cancel activity.");
    }
  }

  @override
  VolunteerActivity fromJson(data) {
    return VolunteerActivity.fromJson(data);
  }
}