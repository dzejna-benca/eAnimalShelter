import '../models/animal_recommendation.dart';
import 'base_provider.dart';

class RecommendationProvider
    extends BaseProvider<AnimalRecommendation> {
  RecommendationProvider()
      : super("Recommendation");

  @override
  AnimalRecommendation fromJson(data) =>
      AnimalRecommendation.fromJson(data);

  Future<List<AnimalRecommendation>>
    getRecommendations({
  int top = 10,
    }) async {
      return await getList(filter: {
        "top": top,
      });
    }
}