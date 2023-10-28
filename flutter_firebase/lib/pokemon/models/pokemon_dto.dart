import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_generation_funtions.dart';

class PokemonDto {
  int? id;
  String? name;
  String? image;
  PokemonGenerations? generation;
  PokemonType? type;
  PokemonType? subType;
  Map<PokemonStats, int>? stats;

  PokemonDto({
    this.id,
    this.name,
    this.image,
    this.type,
    this.subType,
    this.stats,
  });

  PokemonDto.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["sprites"]["front_default"];
    var types = json["types"] as List;
    type = PokemonType.values.firstWhere((element) =>
        element.toString() == "PokemonType.${types[0]["type"]["name"]}");
    if (types.length > 1) {
      subType = PokemonType.values.firstWhere((element) =>
          element.toString() == "PokemonType.${types[1]["type"]["name"]}");
    }
    generation = PokemonRepository().getGeneration(namePokemon: name!);
    stats = {
      PokemonStats.hp: json["stats"][0]["base_stat"],
      PokemonStats.attack: json["stats"][1]["base_stat"],
      PokemonStats.defense: json["stats"][2]["base_stat"],
      PokemonStats.specialAttack: json["stats"][3]["base_stat"],
      PokemonStats.specialDefense: json["stats"][4]["base_stat"],
      PokemonStats.speed: json["stats"][5]["base_stat"],
    };
  }

  String toCsvRow() {
    return "$name,$id,$image,${type.toString().split(".")[1]},${subType == null ? "null" : subType.toString().split(".")[1]},${stats![PokemonStats.hp]},${stats![PokemonStats.attack]},${stats![PokemonStats.defense]},${stats![PokemonStats.specialAttack]},${stats![PokemonStats.specialDefense]},${stats![PokemonStats.speed]},${generation!.name}";
  }

  PokemonDto.fromCsvRow(String e) {
    var values = e.split(",");
    name = values.elementAt(0);
    id = int.parse(values.elementAt(1));
    image = values.elementAt(2);
    type = PokemonType.values.firstWhere((element) =>
        element.toString() == "PokemonType.${values.elementAt(3)}");
    if (values.elementAt(4) != "null") {
      subType = PokemonType.values.firstWhere((element) =>
          element.toString() == "PokemonType.${values.elementAt(4)}");
    }
    stats = {
      PokemonStats.hp: int.parse(values.elementAt(5)),
      PokemonStats.attack: int.parse(values.elementAt(6)),
      PokemonStats.defense: int.parse(values.elementAt(7)),
      PokemonStats.specialAttack: int.parse(values.elementAt(8)),
      PokemonStats.specialDefense: int.parse(values.elementAt(9)),
      PokemonStats.speed: int.parse(values.elementAt(10)),
    };
    generation = PokemonGenerationsFuntions.convert(values.elementAt(11));
  }
}
