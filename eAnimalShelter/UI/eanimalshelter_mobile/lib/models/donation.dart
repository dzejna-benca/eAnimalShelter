class Donation {
  final int donationId;
  final double amount;
  final DateTime? donationDate;
  final String paymentMethod;
  final int transactionStatus;
  final String? note;
  final String? receiptPdfPath;

  Donation({
    required this.donationId,
    required this.amount,
    this.donationDate,
    required this.paymentMethod,
    required this.transactionStatus,
    this.note,
    this.receiptPdfPath,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationId: json["donationId"],
      amount: (json["amount"] as num).toDouble(),
      donationDate: json["donationDate"] != null
          ? DateTime.parse(json["donationDate"])
          : null,
      paymentMethod: json["paymentMethod"],
      transactionStatus:
          json["transactionStatus"] ?? 0,
      note: json["note"],
      receiptPdfPath: json["receiptPdfPath"],
    );
  }
}