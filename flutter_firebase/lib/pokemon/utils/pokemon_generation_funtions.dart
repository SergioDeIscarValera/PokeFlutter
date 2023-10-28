import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';

class PokemonGenerationsFuntions {
  static PokemonGenerations convert(String value) {
    switch (value.toLowerCase()) {
      case "red" ||
            "blue" ||
            "yellow" ||
            "green" ||
            "generation-i" ||
            "red and blue" ||
            "pokemongenerations.i":
        return PokemonGenerations.I;
      case "gold" ||
            "silver" ||
            "crystal" ||
            "generation-ii" ||
            "gold and silver" ||
            "pokemongenerations.ii":
        return PokemonGenerations.II;
      case "ruby" ||
            "sapphire" ||
            "emerald" ||
            "firered" ||
            "leafgreen" ||
            "generation-iii" ||
            "ruby and sapphire" ||
            "pokemongenerations.iii":
        return PokemonGenerations.III;
      case "diamond" ||
            "pearl" ||
            "platinum" ||
            "heartgold" ||
            "soulsilver" ||
            "generation-iv" ||
            "diamond and pearl" ||
            "pokemongenerations.iv":
        return PokemonGenerations.IV;
      case "black" ||
            "white" ||
            "black-2" ||
            "white-2" ||
            "generation-v" ||
            "black and white" ||
            "pokemongenerations.v":
        return PokemonGenerations.V;
      case "x" ||
            "y" ||
            "omega-ruby" ||
            "alpha-sapphire" ||
            "generation-vi" ||
            "x and y" ||
            "pokemongenerations.vi":
        return PokemonGenerations.VI;
      case "sun" ||
            "moon" ||
            "ultra-sun" ||
            "ultra-moon" ||
            "generation-vii" ||
            "sun and moon" ||
            "pokemongenerations.vii":
        return PokemonGenerations.VII;
      case "sword" ||
            "shield" ||
            "generation-viii" ||
            "sword and shield" ||
            "pokemongenerations.viii":
        return PokemonGenerations.VIII;
      case "scarlet" ||
            "violet" ||
            "generation-ix" ||
            "scarlet and violet" ||
            "pokemongenerations.ix":
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
