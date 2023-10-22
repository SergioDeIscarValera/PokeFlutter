import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:get/get.dart';

class PokemonFavoritesStatisticsController {
  final RxInt _touchIndex = (-1).obs;
  int get touchIndex => _touchIndex.value;
  set touchIndex(int value) => _touchIndex.value = value;

  final Rx<PokemonDto?> pokemonSelected = Rx<PokemonDto?>(null);
}
