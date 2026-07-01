import '../models/adoption_request.dart';
import '../models/adoption_request_insert_request.dart';
import 'base_provider.dart';

class AdoptionRequestProvider
    extends BaseProvider<AdoptionRequest> {

  AdoptionRequestProvider()
      : super("AdoptionRequest");

  @override
  AdoptionRequest fromJson(data) {
    return AdoptionRequest.fromJson(data);
  }

  Future<void> submitRequest(
    AdoptionRequestInsertRequest request,
  ) async {
    await postCustom(
      "",
      request.toJson(),
    );
  }

  Future<List<AdoptionRequest>>
      getMyRequests() async {
    final result = await get();

    return result.items;
  }

  Future<void> cancelRequest(
    int id,
  ) async {
    await postCustom(
      "$id/cancel",
      {},
    );

    notifyListeners();
  }
}