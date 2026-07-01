import 'base_provider.dart';

class AnimalViewHistoryProvider extends BaseProvider<dynamic> {
  AnimalViewHistoryProvider()
      : super("AnimalViewHistory");

  @override
  dynamic fromJson(data) => data;

  Future<void> addView(int animalId) async {
    await postVoid("$animalId");
  }
  Future<void> recordView(int animalId) async {
    await postVoid("$animalId/view");
  }
}