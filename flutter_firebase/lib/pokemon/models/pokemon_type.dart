import 'package:flutter/material.dart';

enum PokemonType {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  unknown,
  shadow
}

extension PokemonTypeUtils on PokemonType {
  String get name {
    switch (this) {
      case PokemonType.normal:
        return "Normal";
      case PokemonType.fighting:
        return "Fighting";
      case PokemonType.flying:
        return "Flying";
      case PokemonType.poison:
        return "Poison";
      case PokemonType.ground:
        return "Ground";
      case PokemonType.rock:
        return "Rock";
      case PokemonType.bug:
        return "Bug";
      case PokemonType.ghost:
        return "Ghost";
      case PokemonType.steel:
        return "Steel";
      case PokemonType.fire:
        return "Fire";
      case PokemonType.water:
        return "Water";
      case PokemonType.grass:
        return "Grass";
      case PokemonType.electric:
        return "Electric";
      case PokemonType.psychic:
        return "Psychic";
      case PokemonType.ice:
        return "Ice";
      case PokemonType.dragon:
        return "Dragon";
      case PokemonType.dark:
        return "Dark";
      case PokemonType.fairy:
        return "Fairy";
      case PokemonType.unknown:
        return "Unknown";
      case PokemonType.shadow:
        return "Shadow";
    }
  }

  Color get color {
    switch (this) {
      case PokemonType.normal:
        return const Color(0xFFA8A878);
      case PokemonType.fighting:
        return const Color(0xFFC03028);
      case PokemonType.flying:
        return const Color(0xFFA890F0);
      case PokemonType.poison:
        return const Color(0xFFA040A0);
      case PokemonType.ground:
        return const Color(0xFFE0C068);
      case PokemonType.rock:
        return const Color(0xFFB8A038);
      case PokemonType.bug:
        return const Color(0xFFA8B820);
      case PokemonType.ghost:
        return const Color(0xFF705898);
      case PokemonType.steel:
        return const Color(0xFFB8B8D0);
      case PokemonType.fire:
        return const Color(0xFFF08030);
      case PokemonType.water:
        return const Color(0xFF6890F0);
      case PokemonType.grass:
        return const Color(0xFF78C850);
      case PokemonType.electric:
        return const Color(0xFFF8D030);
      case PokemonType.psychic:
        return const Color(0xFFF85888);
      case PokemonType.ice:
        return const Color(0xFF98D8D8);
      case PokemonType.dragon:
        return const Color(0xFF7038F8);
      case PokemonType.dark:
        return const Color(0xFF705848);
      case PokemonType.fairy:
        return const Color(0xFFEE99AC);
      case PokemonType.unknown:
        return const Color(0xFF68A090);
      case PokemonType.shadow:
        return const Color(0xFF68A090);
    }
  }
}
