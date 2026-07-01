class DonationReport {
  double totalDonations;
  double averageDonation;

  String topDonor;

  Map<String, dynamic> donationsByMonth;

  DonationReport({
    required this.totalDonations,
    required this.averageDonation,
    required this.topDonor,
    required this.donationsByMonth,
  });

  factory DonationReport.fromJson(
    Map<String, dynamic> json,
  ) {
    return DonationReport(
      totalDonations:
          (json["totalDonations"] as num)
              .toDouble(),

      averageDonation:
          (json["averageDonation"] as num)
              .toDouble(),

      topDonor:
          json["topDonor"] ?? "",

      donationsByMonth:
          Map<String, dynamic>.from(
              json["donationsByMonth"] ?? {}),
    );
  }
}