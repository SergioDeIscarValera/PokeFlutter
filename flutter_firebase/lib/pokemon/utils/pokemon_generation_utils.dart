import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';

class PokemonGenerationsUtils {
  static PokemonGenerations convert(String value) {
    switch (value.toLowerCase()) {
      case "red" ||
            "blue" ||
            "yellow" ||
            "green" ||
            "generation-i" ||
            "red and blue":
        return PokemonGenerations.I;
      case "gold" ||
            "silver" ||
            "crystal" ||
            "generation-ii" ||
            "gold and silver":
        return PokemonGenerations.II;
      case "ruby" ||
            "sapphire" ||
            "emerald" ||
            "firered" ||
            "leafgreen" ||
            "generation-iii" ||
            "ruby and sapphire":
        return PokemonGenerations.III;
      case "diamond" ||
            "pearl" ||
            "platinum" ||
            "heartgold" ||
            "soulsilver" ||
            "generation-iv" ||
            "diamond and pearl":
        return PokemonGenerations.IV;
      case "black" ||
            "white" ||
            "black-2" ||
            "white-2" ||
            "generation-v" ||
            "black and white":
        return PokemonGenerations.V;
      case "x" ||
            "y" ||
            "omega-ruby" ||
            "alpha-sapphire" ||
            "generation-vi" ||
            "x and y":
        return PokemonGenerations.VI;
      case "sun" ||
            "moon" ||
            "ultra-sun" ||
            "ultra-moon" ||
            "generation-vii" ||
            "sun and moon":
        return PokemonGenerations.VII;
      case "sword" || "shield" || "generation-viii" || "sword and shield":
        return PokemonGenerations.VIII;
      case "scarlet" || "violet" || "generation-ix" || "scarlet and violet":
        return PokemonGenerations.IX;
      default:
        return PokemonGenerations.Other;
    }
  }

  static Map<PokemonGenerations, List<String>> fromJson(dynamic json) {
    var namesJson = json["pokemon_species"] as List;
    List<String> names = [];
    for (var name in namesJson) {
      names.add(name["name"]);
    }
    return {convert(json["name"]): names};
  }

  static String toCsvRow(PokemonGenerations key, List<String> value) {
    return "${key.name};${value.join(",")}";
  }
}
