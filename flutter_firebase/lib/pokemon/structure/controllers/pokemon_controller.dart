import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_filter_class.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PokemonController extends GetxController {
  RxList<PokemonDto> pokemonList = <PokemonDto>[].obs;

  TextEditingController searchController = TextEditingController();

  int pagination = 10;
  int _offset = 0;

  @override
  void onReady() {
    PokemonRepository().startGetAllPokemon(onLoad: () {
      getPokemonList(limit: pagination, offset: _offset);
    }); // Para que se muestre el loading
    super.onReady();
  }

  Future<PokemonDto?> getPokemon({required int id}) async =>
      await PokemonRepository().getPokemon(name: id.toString());

  void getPokemonList({required int limit, required int offset}) {
    pokemonList.value = []; // Para que se muestre el loading
    pokemonList.value = PokemonRepository()
        .getPokemonListFromCache(limit: limit, offset: offset);
  }

  void getNextPokemonList() {
    if (_offset > 1118) return;
    _offset += pagination;
    getPokemonList(limit: pagination, offset: _offset);
  }

  void getPreviousPokemonList() {
    if (_offset < pagination) return;
    _offset -= pagination;
    getPokemonList(limit: pagination, offset: _offset);
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

  void resetPokemonList() {
    _offset = 0;
    getPokemonList(limit: pagination, offset: _offset);
  }

  void setPaginarion(int pagination) {
    this.pagination = pagination;
  }

  Future<void> filterAllPokemons({required PokemonFilter filter}) async {
    var value = PokemonRepository().getAllPokemonsFilter(filter);
    pokemonList.value = value.sublist(0, value.length > 10 ? 10 : value.length);
  }
}
