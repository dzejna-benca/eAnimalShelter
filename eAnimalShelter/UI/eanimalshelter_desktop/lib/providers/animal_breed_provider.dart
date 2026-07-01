import '../models/animal_breed.dart';
import 'base_provider.dart';

class AnimalBreedProvider
    extends BaseProvider<AnimalBreed> {

  AnimalBreedProvider()
      : super("AnimalBreed");

  @override
  AnimalBreed fromJson(data) {
    return AnimalBreed.fromJson(data);
  }
}