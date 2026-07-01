import '../models/favorite.dart';
import 'base_provider.dart';

class FavoriteProvider
    extends BaseProvider<Favorite> {
  FavoriteProvider()
      : super("Favorite");
  List<int> _favoriteIds = [];

  List<int> get favoriteIds => _favoriteIds;
   Future<void> refreshFavorites() async {
    _favoriteIds = await getMyFavoriteIds();
    notifyListeners();
  }

  @override
  Favorite fromJson(data) =>
      Favorite.fromJson(data);

  Future<List<int>> getMyFavoriteIds() async {
    return await getRawList<int>(
      "my-animal-ids",
    );
  }

  Future<void> toggleFavorite(
      int animalId) async {
    await postVoid(
      "$animalId/toggle",
    );
    await refreshFavorites();
  }
  Future<List<Favorite>> getFavorites() async {
  final result = await get();

  return result.items;
}
@override
Future<void> delete(int id) async {
  await super.delete(id);

  await refreshFavorites();
}
}