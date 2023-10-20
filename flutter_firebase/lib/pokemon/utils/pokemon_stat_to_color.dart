import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:flutter/material.dart';

class PokemonStatsToColor {
  static final Map<PokemonStats, int> _statToColor = {
    PokemonStats.hp: 0xFFA8A878,
    PokemonStats.attack: 0xFFF08030,
    PokemonStats.defense: 0xFF6890F0,
    PokemonStats.specialAttack: 0xFFF8D030,
    PokemonStats.specialDefense: 0xFF78C850,
    PokemonStats.speed: 0xFF98D8D8,
  };

  static Color getColor(PokemonStats stat, Color defaultColor) {
    return Color(_statToColor[stat] ?? defaultColor.value);
  }
}
