class Donation {
  int? donationId;
  int? userId;

  String? userFullName;

  double? amount;

  DateTime? donationDate;

  String? paymentMethod;

  String? stripePaymentIntentId;

  int transactionStatus;

  String? note;

  String? receiptPdfPath;

  Donation({
    this.donationId,
    this.userId,
    this.userFullName,
    this.amount,
    this.donationDate,
    this.paymentMethod,
    this.stripePaymentIntentId,
    this.transactionStatus = 2,
    this.note,
    this.receiptPdfPath,
  });

  factory Donation.fromJson(
    Map<String, dynamic> json,
  ) {
    return Donation(
      donationId: json["donationId"],
      userId: json["userId"],
      userFullName: json["userFullName"],
      amount: (json["amount"] as num?)?.toDouble(),
      donationDate: json["donationDate"] != null
          ? DateTime.parse(json["donationDate"])
          : null,
      paymentMethod: json["paymentMethod"],
      stripePaymentIntentId: json["transactionId"],
      transactionStatus:
          json["transactionStatus"] ?? 0,
      note: json["note"],
      receiptPdfPath:
          json["receiptPdfPath"],
    );
  }
}