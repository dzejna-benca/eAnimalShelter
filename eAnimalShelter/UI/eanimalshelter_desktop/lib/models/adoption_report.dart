class AdoptionReport {
  int totalRequests;
  int pendingRequests;
  int approvedRequests;
  int rejectedRequests;
  int cancelledRequests;

  Map<String, dynamic> requestsByMonth;

  AdoptionReport({
    required this.totalRequests,
    required this.pendingRequests,
    required this.approvedRequests,
    required this.rejectedRequests,
    required this.cancelledRequests,
    required this.requestsByMonth,
  });

  factory AdoptionReport.fromJson(
      Map<String, dynamic> json) {
    return AdoptionReport(
      totalRequests: json["totalRequests"],
      pendingRequests: json["pendingRequests"],
      approvedRequests: json["approvedRequests"],
      rejectedRequests: json["rejectedRequests"],
      cancelledRequests: json["cancelledRequests"],
      requestsByMonth:
          Map<String, dynamic>.from(
              json["requestsByMonth"] ?? {}),
    );
  }
}