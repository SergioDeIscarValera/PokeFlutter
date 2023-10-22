import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_favorites_statistics_controller.dart';
import 'package:get/get.dart';

class PokemonFavoritesStatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PokemonFavoritesStatisticsController>(
        () => PokemonFavoritesStatisticsController());
  }
}
