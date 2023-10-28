import 'package:flutter/material.dart';

enum PokemonStats { hp, attack, defense, specialAttack, specialDefense, speed }

extension PokemonStatsUtils on PokemonStats {
  String get name {
    switch (this) {
      case PokemonStats.hp:
        return "Hp";
      case PokemonStats.attack:
        return "Att";
      case PokemonStats.defense:
        return "Def";
      case PokemonStats.specialAttack:
        return "S-Att";
      case PokemonStats.specialDefense:
        return "S-Def";
      case PokemonStats.speed:
        return "Spe";
    }
  }

  Color get color {
    switch (this) {
      case PokemonStats.hp:
        return const Color(0xFFA8A878);
      case PokemonStats.attack:
        return const Color(0xFFF08030);
      case PokemonStats.defense:
        return const Color(0xFF6890F0);
      case PokemonStats.specialAttack:
        return const Color(0xFFF8D030);
      case PokemonStats.specialDefense:
        return const Color(0xFF78C850);
      case PokemonStats.speed:
        return const Color(0xFF98D8D8);
    }
  }
}
