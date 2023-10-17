import 'package:PokeFlutter/pokemon/models/type_pokemon.dart';

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
      this.weight});

  int? id;
  String? name;
  String? image;
  String? imageShiny;
  Map<String, int>? stats;
  TypePokemon? type;
  TypePokemon? subType;
  int? height;
  int? weight;

  PokemonFullInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["sprites"]["front_default"];
    imageShiny = json["sprites"]["front_shiny"];
    stats = {
      "hp": json["stats"][0]["base_stat"],
      "att": json["stats"][1]["base_stat"],
      "def": json["stats"][2]["base_stat"],
      "spe-att": json["stats"][3]["base_stat"],
      "spe-def": json["stats"][4]["base_stat"],
      "spe": json["stats"][5]["base_stat"],
    };
    var types = json["types"] as List;
    type = TypePokemon.values.firstWhere((element) =>
        element.toString() == "TypePokemon.${types[0]["type"]["name"]}");
    if (types.length > 1) {
      subType = TypePokemon.values.firstWhere((element) =>
          element.toString() == "TypePokemon.${types[1]["type"]["name"]}");
    }
    height = json["height"];
    weight = json["weight"];
  }
}
