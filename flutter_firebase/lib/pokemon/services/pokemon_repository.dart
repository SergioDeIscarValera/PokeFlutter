import 'dart:convert';
import 'package:http/http.dart';
import 'package:namer_app/pokemon/models/pokemon.dart';
import 'package:namer_app/pokemon/services/pokemon_api_repository.dart';

class PokemonRepository{
  Future<Pokemon?> getPokemon({required String name}) async {
    try{
      Response bodyResponse = await PokemonApiRepository().getPokemon(name: name);
      final body = bodyResponse.body;
      final Pokemon pokemon = Pokemon.fromJson(jsonDecode(body));
      return pokemon;
    }catch(e){
      return null;
    }
  }

  Future<List<Pokemon>> getPokemonList({required int limit, required int offset}) async {
    try{
      Response bodyResponse = await PokemonApiRepository().getPokemonList(limit: limit, offset: offset);
      final body = bodyResponse.body;
      final json = jsonDecode(body);
      final List<Pokemon> pokemonList = [];
      for(var pokemon in json["results"]){
        final Pokemon? pokemonObj = await getPokemon(name: pokemon["name"]);
        if (pokemonObj != null) {
          pokemonList.add(pokemonObj);
        }
      }
      return pokemonList;
    }catch(e){
      return Future.error(e);
    }
  }
}