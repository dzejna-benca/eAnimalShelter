import '../models/animal_species.dart';
import 'base_provider.dart';

class AnimalSpeciesProvider
    extends BaseProvider<AnimalSpecies> {

  AnimalSpeciesProvider()
      : super("AnimalSpecies");

  @override
  AnimalSpecies fromJson(data) {
    return AnimalSpecies.fromJson(data);
  }
}