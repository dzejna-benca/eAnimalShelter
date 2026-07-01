import '../models/animal.dart';
import 'base_provider.dart';

class AnimalProvider
    extends BaseProvider<Animal> {

  AnimalProvider()
      : super("Animal");

  @override
  Animal fromJson(data) {
    return Animal.fromJson(data);
  }
}