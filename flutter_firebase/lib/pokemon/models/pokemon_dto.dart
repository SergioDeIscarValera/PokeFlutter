import 'package:PokeFlutter/pokemon/models/type_pokemon.dart';

class PokemonDto {
  int? id;
  String? name;
  String? image;
  TypePokemon? type;
  TypePokemon? subType;

  PokemonDto({this.id, this.name, this.image, this.type, this.subType});

  PokemonDto.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    image = json["sprites"]["front_default"];
    var types = json["types"] as List;
    type = TypePokemon.values.firstWhere((element) =>
        element.toString() == "TypePokemon.${types[0]["type"]["name"]}");
    if (types.length > 1) {
      subType = TypePokemon.values.firstWhere((element) =>
          element.toString() == "TypePokemon.${types[1]["type"]["name"]}");
    }
  }
}
