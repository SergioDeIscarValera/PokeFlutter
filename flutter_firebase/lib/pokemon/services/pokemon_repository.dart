import 'dart:convert';
import 'dart:io';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_filter_class.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_full_info.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_api_repository.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_generation_funtions.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

const ALL_POKEMONS_FILE = "allPokemons.csv";
const ALL_GENERATIONS_FILE = "allGenerations.csv";

class PokemonRepository {
  static final List<PokemonDto> _allPokemons = [];
  static final Map<PokemonGenerations, List<String>> _generationsNames = {};
  final int _pokemonCount = 1118;
  final int _processCount = 26;

  //#region ApiCalls

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
      return PokemonFullInfo.fromJson(jsonDecode(body));
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<PokemonGenerations, List<String>>> _getGenerationNames(
      PokemonGenerations gen) async {
    try {
      Response bodyResponse = await PokemonApiRepository()
          .getGeneration(name: (gen.index + 1).toString());
      final body = bodyResponse.body;
      return PokemonGenerationsFuntions.fromJson(jsonDecode(body));
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<String>> getMovesById({required int id}) async {
    try {
      Response bodyResponse =
          await PokemonApiRepository().getPokemon(name: id.toString());
      final body = bodyResponse.body;
      final json = jsonDecode(body);
      final List<String> moves = [];
      for (var move in json["moves"]) {
        moves.add(move["move"]["name"]);
      }
      return moves;
    } catch (e) {
      return Future.error(e);
    }
  }

  //#endregion

  PokemonDto getPokemonFromCacheById({required int id}) {
    return _allPokemons.firstWhere((pokemon) => pokemon.id == id);
  }

  List<PokemonDto> getPokemonListFromCache(
      {required int limit, required int offset}) {
    return _allPokemons.sublist(
        offset,
        _allPokemons.length > offset + limit
            ? offset + limit
            : _allPokemons.length);
  }

  List<PokemonDto> getAllPokemons() {
    return _allPokemons;
  }

  List<PokemonDto> getAllPokemonsFilter(PokemonFilter filter) {
    return _allPokemons.where((pokemon) {
      if (filter.textFild != null &&
          !pokemon.name!
              .toLowerCase()
              .contains(filter.textFild!.toLowerCase())) {
        return false;
      }
      if (filter.type != null && pokemon.type != filter.type) {
        if (pokemon.subType != null ? pokemon.subType != filter.type : true) {
          return false;
        }
      }
      if (filter.subType != null && pokemon.type != filter.subType) {
        if (pokemon.subType != null
            ? pokemon.subType != filter.subType
            : true) {
          return false;
        }
      }

      if (filter.stats != null) {
        var stats = pokemon.stats!;
        var filterStats = filter.stats!.values.toList();

        for (int i = 0; i < filterStats.length; i++) {
          if (filterStats[i].start > stats[PokemonStats.values[i]]! ||
              filterStats[i].end < stats[PokemonStats.values[i]]!) {
            return false;
          }
        }
      }

      if (filter.generation != null &&
          pokemon.generation != filter.generation) {
        return false;
      }

      return true;
    }).toList();
  }

  PokemonGenerations getGeneration({required String namePokemon}) {
    for (var generation in _generationsNames.entries) {
      if (generation.value.contains(namePokemon)) {
        return generation.key;
      }
    }
    return PokemonGenerations.IX;
  }

  Future<void> startGetAllPokemon({required Function onLoad}) async {
    final String allPokemonsFilePath = await _getAllPokemonsFilePath();
    await _loadAllGenerationsNames();

    // Si el archivo existe, cargar los datos, si falla, borrar el archivo y si el archivo es de hace más de un mes, borrarlo
    try {
      if (await File(allPokemonsFilePath).exists()) {
        await allPokemonsReedFicheroCsv(allPokemonsFilePath);
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
        onLoad.call(); // Mostrar pokemones en la primera tanda
        onLoad = () {}; // Clear funtion
      } else if (i == _processCount - 1) {
        _allPokemons.addAll(await Future.wait(processList)
            .then((value) => value.expand((element) => element).toList()));
        processList.clear();
      }
    }

    // Al final, guardar los datos en el archivo
    await _allPokemonsWriteCsv(allPokemonsFilePath);
  }

  Future<void> allPokemonsReedFicheroCsv(String filePath) async =>
      _allPokemons.addAll(await _reedCsvFile(filePath)
          .then((value) => value.map((e) => PokemonDto.fromCsvRow(e))));

  Future<void> _allPokemonsWriteCsv(String allPokemonsFilePath) async {
    final List<String> csvData =
        _allPokemons.map((pokemon) => pokemon.toCsvRow()).toList();
    csvData[0].replaceAll("[\"", "");
    csvData[csvData.length - 1].replaceAll("\"]", "");
    await File(allPokemonsFilePath).writeAsString(csvData.join("|"));
  }

  Future<String> _getAllPokemonsFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}${Platform.pathSeparator}$ALL_POKEMONS_FILE';
  }

  //#region Generation

  Future<void> _loadAllGenerationsNames() async {
    final String generationsNameFilePath = await _getGenerationsNameFilePath();
    try {
      if (await File(generationsNameFilePath).exists()) {
        await _generationsReedFicheroCsv(generationsNameFilePath);
        return;
      }
    } catch (e) {
      // Borramos el archivo si no se puede leer o si es de hace más de un mes
      await File(generationsNameFilePath).delete();
    }

    final int limitProcessSimultaneous = PokemonGenerations.values.length ~/ 3;

    List<Future<Map<PokemonGenerations, List<String>>>> processList = [];
    for (int i = 0; i < PokemonGenerations.values.length - 1; i++) {
      processList.add(_getGenerationNames(PokemonGenerations.values[i]));
      if (processList.length == limitProcessSimultaneous) {
        var listMap = await Future.wait(processList).then(
            (value) => value.expand((element) => element.entries).toList());
        for (var map in listMap) {
          _generationsNames.addAll({map.key: map.value});
        }
        processList.clear();
      } else if (i == PokemonGenerations.values.length - 1) {
        var listMap = await Future.wait(processList).then(
            (value) => value.expand((element) => element.entries).toList());
        for (var map in listMap) {
          _generationsNames.addAll({map.key: map.value});
        }
        processList.clear();
      }
    }

    await _generationsWriteCsv(generationsNameFilePath);
  }

  Future<void> _generationsWriteCsv(String generationsNameFilePath) async {
    final List<String> csvData = _generationsNames.entries
        .map((map) => PokemonGenerationsFuntions.toCsvRow(map.key, map.value))
        .toList();
    await File(generationsNameFilePath).writeAsString(csvData.join("|"));
  }

  Future<void> _generationsReedFicheroCsv(
      String generationsNameFilePath) async {
    final List<String> csvData = await _reedCsvFile(generationsNameFilePath);
    // Key: generation, Value: names
    csvData
        .map((tupla) => {
              PokemonGenerationsFuntions.convert(tupla.split(";")[0]):
                  tupla.split(";")[1].split(",")
            })
        .forEach((mapedValue) => _generationsNames.addAll(mapedValue));
  }

  Future<String> _getGenerationsNameFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}${Platform.pathSeparator}$ALL_GENERATIONS_FILE';
  }

  //#endregion

  Future<List<String>> _reedCsvFile(String filePath) async {
    var fileDate = await File(filePath).lastModified();
    var toDay = DateTime.now();

    if (toDay.difference(fileDate).inDays > 30) {
      throw Exception("El archivo es de hace más de un mes");
    }

    final String fileContent = await File(filePath).readAsString();
    return fileContent.split("|");
  }
}
