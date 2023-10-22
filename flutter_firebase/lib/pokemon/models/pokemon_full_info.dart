import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';

class PokemonFullInfo {
  PokemonFullInfo(
      {this.id,
      this.name,
      this.stats,
      this.type,
      this.subType,
      this.image,
      this.imageShiny,
      this.height,
      this.weight,
      this.generations});

  int? id;
  String? name;
  String? image;
  String? imageShiny;
  Map<PokemonStats, int>? stats;
  PokemonType? type;
  PokemonType? subType;
  int? height;
  int? weight;
  PokemonGenerations? generations;

  PokemonFullInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["sprites"]["front_default"];
    imageShiny = json["sprites"]["front_shiny"];
    stats = {
      PokemonStats.hp: json["stats"][0]["base_stat"],
      PokemonStats.attack: json["stats"][1]["base_stat"],
      PokemonStats.defense: json["stats"][2]["base_stat"],
      PokemonStats.specialAttack: json["stats"][3]["base_stat"],
      PokemonStats.specialDefense: json["stats"][4]["base_stat"],
      PokemonStats.speed: json["stats"][5]["base_stat"],
    };
    var types = json["types"] as List;
    type = PokemonType.values.firstWhere((element) =>
        element.toString() == "PokemonType.${types[0]["type"]["name"]}");
    if (types.length > 1) {
      subType = PokemonType.values.firstWhere((element) =>
          element.toString() == "PokemonType.${types[1]["type"]["name"]}");
    }
    height = json["height"];
    weight = json["weight"];

    generations = PokemonRepository().getGeneration(namePokemon: name!);
  }
}
