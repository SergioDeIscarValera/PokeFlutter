import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:get/get.dart';

class PokemonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PokemonController>(() => PokemonController());
  }
}
