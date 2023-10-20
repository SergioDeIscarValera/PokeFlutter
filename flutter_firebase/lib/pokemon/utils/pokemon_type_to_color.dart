import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:flutter/material.dart';

class PokemonTypeToColor {
  static final Map<PokemonType, int> _typeToColor = {
    PokemonType.normal: 0xFFA8A878,
    PokemonType.fire: 0xFFF08030,
    PokemonType.water: 0xFF6890F0,
    PokemonType.electric: 0xFFF8D030,
    PokemonType.grass: 0xFF78C850,
    PokemonType.ice: 0xFF98D8D8,
    PokemonType.fighting: 0xFFC03028,
    PokemonType.poison: 0xFFA040A0,
    PokemonType.ground: 0xFFE0C068,
    PokemonType.flying: 0xFFA890F0,
    PokemonType.psychic: 0xFFF85888,
    PokemonType.bug: 0xFFA8B820,
    PokemonType.rock: 0xFFB8A038,
    PokemonType.ghost: 0xFF705898,
    PokemonType.dragon: 0xFF7038F8,
    PokemonType.dark: 0xFF705848,
    PokemonType.steel: 0xFFB8B8D0,
    PokemonType.fairy: 0xFFEE99AC,
  };

  static Color getColor(PokemonType? type, Color defaultColor) {
    if (type == null) return defaultColor;
    return Color(_typeToColor[type] ?? defaultColor.value);
  }
}
