import '../models/create_payment_intent_request.dart';
import '../models/create_payment_intent_response.dart';
import '../models/donation.dart';
import '../models/search_result.dart';
import 'base_provider.dart';

class DonationProvider
    extends BaseProvider<Donation> {
  DonationProvider()
      : super("Donation");

  @override
  Donation fromJson(data) =>
      Donation.fromJson(data);

  Future<CreatePaymentIntentResponse>
      createPaymentIntent(
    CreatePaymentIntentRequest request,
  ) async {
    final json = await postRaw(
      "create-payment-intent",
      request.toJson(),
    );

    return CreatePaymentIntentResponse
        .fromJson(json);
  }

  Future<SearchResult<Donation>>
      getMyDonations() async {
    return get();
  }
  Future<List<int>> downloadReceipt(
    int donationId,
) async {
  return downloadFile(
    "$donationId/receipt",
  );
}
Future<void> confirmPayment(
  int donationId,
) async {
  await postVoid(
    "$donationId/confirm-payment",
  );
}
}