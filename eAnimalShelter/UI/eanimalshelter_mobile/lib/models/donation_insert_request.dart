class DonationInsertRequest {
  final double amount;
  final String? note;

  DonationInsertRequest({
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "note": note,
      };
}