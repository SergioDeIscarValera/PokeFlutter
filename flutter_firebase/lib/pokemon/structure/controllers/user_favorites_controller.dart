import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_firebase_repository.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:get/get.dart';

class UserFavoritesController extends GetxController {
  RxList<PokemonDto> favorites = <PokemonDto>[].obs;

  Future<void> changeFavorite(
      {required String email, required PokemonDto poke}) async {
    if (isFavorite(poke: poke)) {
      await _removeFavorite(email: email, poke: poke);
    } else {
      await _addFavorite(email: email, poke: poke);
    }
  }

  Future<void> _addFavorite(
      {required String email, required PokemonDto poke}) async {
    await refreshFavorites(email: email, pokemonController: Get.find());
    favorites.add(poke);
    favorites.value = favorites.value.toSet().toList();
    await PokemonFireBaseRepository().setFavorites(
        email: email, favorites: _pokemonsToIds(pokemons: favorites.toList()));
  }

  Future<void> _removeFavorite(
      {required String email, required PokemonDto poke}) async {
    await refreshFavorites(email: email, pokemonController: Get.find());
    favorites.removeWhere((element) => element.id == poke.id);
    await PokemonFireBaseRepository().setFavorites(
        email: email, favorites: _pokemonsToIds(pokemons: favorites.toList()));
  }

  Future<void> refreshFavorites(
      {required String email,
      required PokemonController pokemonController}) async {
    List<int> favoriteFirebase =
        await PokemonFireBaseRepository().getFavorites(email: email);
    var pokemons = await Future.wait(
        favoriteFirebase.map((id) => pokemonController.getPokemon(id: id)));
    favorites.value = pokemons
        .where((element) => element != null)
        .map((e) => e!)
        .toSet()
        .toList();
  }

  bool isFavorite({required PokemonDto poke}) {
    var value = _pokemonsToIds(pokemons: favorites.toList()).contains(poke.id!);
    return value;
  }

  List<int> _pokemonsToIds({required List<PokemonDto> pokemons}) {
    return pokemons.map((e) => e.id ?? 0).toList();
  }
}
