import 'package:namer_app/pokemon/models/type_pokemon.dart';

class Pokemon{
  int? id;
  String? name;
  Map<String, int>? stats;
  String? image;
  TypePokemon? type;

  Pokemon({ this.id, this.name, this.stats, this.image, this.type });

  Pokemon.fromJson(Map<String, dynamic> json){
    name = json["name"];
    id = json["id"];
    image = json["sprites"]["front_default"];
    stats = {
      "hp": json["stats"][0]["base_stat"],
      "attack": json["stats"][1]["base_stat"],
      "defense": json["stats"][2]["base_stat"],
      "special-attack": json["stats"][3]["base_stat"],
      "special-defense": json["stats"][4]["base_stat"],
      "speed": json["stats"][5]["base_stat"],
    };
    type = TypePokemon.values.firstWhere((element) => element.toString() == "TypePokemon.${json["types"][0]["type"]["name"]}");
  }
}