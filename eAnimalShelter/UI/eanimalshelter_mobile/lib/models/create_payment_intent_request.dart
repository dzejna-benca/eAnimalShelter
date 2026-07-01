class CreatePaymentIntentRequest {
  final double amount;
  final String? note;

  CreatePaymentIntentRequest({
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "note": note,
      };
}