import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:namer_app/pokemon/models/pokemon.dart';
import 'package:namer_app/pokemon/services/pokemon_repository.dart';

class PokemonController extends GetxController{
  RxList<Pokemon> pokemonList = <Pokemon>[].obs;

  TextEditingController searchController = TextEditingController();

  int _offset = 0;

  Future<Pokemon?> getPokemon({required int id}) async => 
    await PokemonRepository().getPokemon(name: id.toString());

  Future<void> getPokemonList({required int limit, required int offset}) async {
    pokemonList.value = []; // Para que se muestre el loading
    pokemonList.value = await PokemonRepository().getPokemonList(limit: limit, offset: offset);
  }

  Future<void> getNextPokemonList() async {
    if (_offset > 1118) return;
    _offset += 6;
    await getPokemonList(limit: 6, offset: _offset);
  }

  Future<void> getPreviousPokemonList() async {
    if (_offset < 6) return;
    _offset -= 6;
    await getPokemonList(limit: 6, offset: _offset);
  }

  Future<void> searchPokemonByName({
    required String name,
    required Function onFail
  }) async {
    if(name.isEmpty) {
      resetPokemonList();
      return;
    }
    pokemonList.value = []; // Para que se muestre el loading
    var newValue = await PokemonRepository().getPokemon(name: name.trim().toLowerCase()).then((value) => [value]);
    if (newValue.any((element) => element != null)) {
      pokemonList.value = newValue.where((element) => element != null).map((e) => e!).toList();
    }else{
      //newValue = [];
      onFail.call();
      resetPokemonList();
    }
  }

  Future<void> resetPokemonList() async {
    _offset = 0;
    await getPokemonList(limit: 6, offset: _offset);
  }
}