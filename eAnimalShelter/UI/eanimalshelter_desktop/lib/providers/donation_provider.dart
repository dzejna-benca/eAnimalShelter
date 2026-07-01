import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/donation.dart';
import '../models/donation_report.dart';
import 'base_provider.dart';

class DonationProvider
    extends BaseProvider<Donation> {
  DonationProvider()
      : super("Donation");

  @override
  Donation fromJson(data) {
    return Donation.fromJson(data);
  }

  Future<DonationReport> getReport() async {
    var url =
        "${BaseProvider.baseUrl}Donation/report";

    var response = await http.get(
      Uri.parse(url),
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      return DonationReport.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Unable to load report.",
    );
  }
}