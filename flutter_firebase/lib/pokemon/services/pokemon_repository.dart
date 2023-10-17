import 'dart:convert';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_full_info.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_api_repository.dart';
import 'package:http/http.dart';

class PokemonRepository {
  Future<PokemonDto?> getPokemon({required String name}) async {
    try {
      Response bodyResponse =
          await PokemonApiRepository().getPokemon(name: name);
      final body = bodyResponse.body;
      final PokemonDto pokemon = PokemonDto.fromJson(jsonDecode(body));
      return pokemon;
    } catch (e) {
      return null;
    }
  }

  Future<List<PokemonDto>> getPokemonList(
      {required int limit, required int offset}) async {
    try {
      Response bodyResponse = await PokemonApiRepository()
          .getPokemonList(limit: limit, offset: offset);
      final body = bodyResponse.body;
      final json = jsonDecode(body);
      final List<PokemonDto> pokemonList = [];
      for (var pokemon in json["results"]) {
        final PokemonDto? pokemonObj = await getPokemon(name: pokemon["name"]);
        if (pokemonObj != null) {
          pokemonList.add(pokemonObj);
        }
      }
      return pokemonList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<PokemonFullInfo> getFullPokemonById({required int id}) async {
    try {
      Response bodyResponse =
          await PokemonApiRepository().getPokemon(name: id.toString());
      final body = bodyResponse.body;
      final PokemonFullInfo pokemon =
          PokemonFullInfo.fromJson(jsonDecode(body));
      return pokemon;
    } catch (e) {
      return Future.error(e);
    }
  }
}
