//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class PokemonApiRepository {
  Future<http.Response> getPokemon({required String name}) async =>
      await http.get(Uri.https("pokeapi.co", "/api/v2/pokemon/$name"));

  Future<http.Response> getPokemonList(
          {required int limit, required int offset}) async =>
      await http.get(Uri.https("pokeapi.co", "/api/v2/pokemon",
          {"limit": limit.toString(), "offset": offset.toString()}));
}
