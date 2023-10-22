import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:flutter/material.dart';

class PokemonGenerationsUtils {
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

  static final Map<PokemonGenerations, Gradient> _generationToColor = {
    PokemonGenerations.I: const LinearGradient(
      colors: [
        Color(0xFFff0000),
        Color(0xFF0000ff),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.II: const LinearGradient(
      colors: [
        Color(0xFFd2c21a),
        Color(0xFFa0a0a0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.III: const LinearGradient(
      colors: [
        Color(0xFFb90303),
        Color(0xFF0d00b8),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.IV: const LinearGradient(
      colors: [
        Color(0xFF6077ff),
        Color(0xFFfc72e4),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.V: const LinearGradient(
      colors: [
        Color(0xFF424242),
        Color(0xFFf2f2f2),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.VI: const LinearGradient(
      colors: [
        Color(0xFF0084c3),
        Color(0xFF8f0305),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.VII: const LinearGradient(
      colors: [
        Color(0xFFffa500),
        Color(0xFFb401ff),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.VIII: const LinearGradient(
      colors: [
        Color(0xFF00a8ee),
        Color(0xFFff0060),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    PokemonGenerations.IX: const LinearGradient(
      colors: [
        Color(0xFFa2130a),
        Color(0xFF500d69),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  };

  static Gradient getGradient(
      PokemonGenerations? generation, Color defaultColor) {
    return _generationToColor[generation] ??
        LinearGradient(
          colors: [
            defaultColor,
            defaultColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
  }
}
