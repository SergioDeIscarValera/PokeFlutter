import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_full_info.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PokemonController extends GetxController {
  RxList<PokemonDto> pokemonList = <PokemonDto>[].obs;
  Rx<PokemonFullInfo> pokemonSelected = PokemonFullInfo().obs;

  TextEditingController searchController = TextEditingController();

  int pagination = 10;
  int _offset = 0;

  Future<PokemonDto?> getPokemon({required int id}) async =>
      await PokemonRepository().getPokemon(name: id.toString());

  Future<void> getPokemonList({required int limit, required int offset}) async {
    pokemonList.value = []; // Para que se muestre el loading
    pokemonList.value =
        await PokemonRepository().getPokemonList(limit: limit, offset: offset);
  }

  Future<void> getNextPokemonList() async {
    if (_offset > 1118) return;
    _offset += pagination;
    await getPokemonList(limit: pagination, offset: _offset);
  }

  Future<void> getPreviousPokemonList() async {
    if (_offset < pagination) return;
    _offset -= pagination;
    await getPokemonList(limit: pagination, offset: _offset);
  }

  Future<void> searchPokemonByName(
      {required String name, required Function onFail}) async {
    if (name.isEmpty) {
      resetPokemonList();
      return;
    }
    pokemonList.value = []; // Para que se muestre el loading
    var newValue = await PokemonRepository()
        .getPokemon(name: name.trim().toLowerCase())
        .then((value) => [value]);
    if (newValue.any((element) => element != null)) {
      pokemonList.value =
          newValue.where((element) => element != null).map((e) => e!).toList();
    } else {
      onFail.call();
      resetPokemonList();
    }
  }

  Future<void> resetPokemonList() async {
    _offset = 0;
    await getPokemonList(limit: pagination, offset: _offset);
  }

  void setPaginarion(int pagination) {
    this.pagination = pagination;
  }

  Future<void> getFullPokemonById({required int id}) async {
    pokemonSelected.value =
        await PokemonRepository().getFullPokemonById(id: id);
  }

  void unselectPokemon() {
    pokemonSelected.value = PokemonFullInfo();
  }
}
