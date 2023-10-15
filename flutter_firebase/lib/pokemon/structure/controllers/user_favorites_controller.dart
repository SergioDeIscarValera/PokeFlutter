import 'package:get/get.dart';
import 'package:namer_app/pokemon/models/pokemon.dart';
import 'package:namer_app/pokemon/services/pokemon_firebase_repository.dart';
import 'package:namer_app/pokemon/structure/controllers/pokemon_controller.dart';

class UserFavoritesController extends GetxController {
  RxSet<Pokemon> favorites = <Pokemon>{}.obs;

  Future<void> changeFavorite({
    required String email, 
    required Pokemon poke
  }) async {
    if (isFavorite(poke: poke)) {
      await _removeFavorite(email: email, poke: poke);
    } else {
      await _addFavorite(email: email, poke: poke);
    }
  }

  Future<void> _addFavorite({
    required String email, 
    required Pokemon poke
  }) async {
    favorites.add(poke);
    await PokemonFireBaseRepository().setFavorites(
      email: email,
      favorites: _pokemonsToIds(pokemons: favorites.value.toList())
    );
  }

  Future<void> _removeFavorite({
    required String email, 
    required Pokemon poke
  }) async {
    favorites.removeWhere((element) => element.id == poke.id);
    await PokemonFireBaseRepository().setFavorites(
      email: email,
      favorites: _pokemonsToIds(pokemons: favorites.value.toList())
    );
  }

  Future<void> refreshFavorites({
    required String email,
    required PokemonController pokemonController
  }) async {
    List<int> favoriteFirebase = await PokemonFireBaseRepository().getFavorites(email: email);
    var pokemons = await Future.wait(favoriteFirebase.map((id) => pokemonController.getPokemon(id: id)));
    favorites.value = pokemons.where((element) => element != null).map((e) => e!).toSet();
  }

  bool isFavorite({required Pokemon poke}) {
    var value = _pokemonsToIds(pokemons: favorites.value.toList()).contains(poke.id!);
    return value;
  }

  List<int> _pokemonsToIds({required List<Pokemon> pokemons}) {
    return pokemons.map((e) => e.id ?? 0).toList();
  }
}