import 'package:get/get.dart';
import 'package:namer_app/pokemon/structure/controllers/pokemon_controller.dart';

class PokemonBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PokemonController>(() => PokemonController());
  }
}