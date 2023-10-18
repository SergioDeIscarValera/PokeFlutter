import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_full_info.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_api_repository.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

const ALL_POKEMONS_FILE = "allPokemons.csv";

class PokemonRepository {
  static final List<PokemonDto> _allPokemons = [];
  final int _pokemonCount = 1118;
  final int _processCount = 26;

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

  List<PokemonDto> getPokemonListFromCache(
      {required int limit, required int offset}) {
    return _allPokemons.sublist(
        offset,
        _allPokemons.length > offset + limit
            ? offset + limit
            : _allPokemons.length);
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

  List<PokemonDto> getAllPokemons() {
    return _allPokemons;
  }

  Future<void> startGetAllPokemon({required Function onLoad}) async {
    final String allPokemonsFilePath = await _getAllPokemonsFilePath();

    // Si el archivo existe, cargar los datos, si falla, borrar el archivo y si el archivo es de hace más de un mes, borrarlo
    try {
      if (await File(allPokemonsFilePath).exists()) {
        await leerFicheroCsv(allPokemonsFilePath);
        onLoad.call();
        return;
      }
    } catch (e) {
      // Borramos el archivo si no se puede leer o si es de hace más de un mes
      await File(allPokemonsFilePath).delete();
    }

    final int pokemonPerProcess = _pokemonCount ~/ _processCount;
    final int limitProcessSimultaneous = _processCount ~/ 4;

    List<Future<List<PokemonDto>>> processList = [];
    for (int i = 0; i < _processCount; i++) {
      processList.add(getPokemonList(
          limit: pokemonPerProcess, offset: i * pokemonPerProcess));
      if (processList.length == limitProcessSimultaneous) {
        _allPokemons.addAll(await Future.wait(processList)
            .then((value) => value.expand((element) => element).toList()));
        processList.clear();
      } else if (i == _processCount - 1) {
        _allPokemons.addAll(await Future.wait(processList)
            .then((value) => value.expand((element) => element).toList()));
        processList.clear();
      }
    }

    onLoad.call();

    // Al final, guardar los datos en el archivo
    await escribirFicheroCsv(allPokemonsFilePath);
  }

  Future<void> leerFicheroCsv(String allPokemonsFilePath) async {
    var fileDate = await File(allPokemonsFilePath).lastModified();
    var toDay = DateTime.now();

    if (toDay.difference(fileDate).inDays > 30) {
      throw Exception("El archivo es de hace más de un mes");
    }

    final String fileContent = await File(allPokemonsFilePath).readAsString();
    final List<dynamic> csvData = fileContent.split("|");

    _allPokemons.addAll(csvData.map((e) => PokemonDto.fromCsvRow(e)));
  }

  Future<void> escribirFicheroCsv(String allPokemonsFilePath) async {
    final List<String> csvData =
        _allPokemons.map((pokemon) => pokemon.toCsvRow()).toList();
    csvData[0].replaceAll("[\"", "");
    csvData[csvData.length - 1].replaceAll("\"]", "");
    await File(allPokemonsFilePath).writeAsString(csvData.join("|"));
  }
}

Future<String> _getAllPokemonsFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}${Platform.pathSeparator}$ALL_POKEMONS_FILE';
}
