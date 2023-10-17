import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_info_controller.dart';
import 'package:get/get.dart';

class PokemonInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PokemonInfoController>(() => PokemonInfoController());
  }
}
