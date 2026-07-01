class CreatePaymentIntentResponse {
  final String clientSecret;
  final int donationId;

  CreatePaymentIntentResponse({
    required this.clientSecret,
    required this.donationId,
  });

  factory CreatePaymentIntentResponse.fromJson(
      Map<String, dynamic> json) {
    return CreatePaymentIntentResponse(
      clientSecret: json["clientSecret"],
      donationId: json["donationId"],
    );
  }
}