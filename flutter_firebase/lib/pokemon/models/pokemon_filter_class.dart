import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:flutter/material.dart';

class PokemonFilter {
  const PokemonFilter({
    this.textFild,
    this.type,
    this.subType,
    this.stats,
    this.generation,
  });

  final String? textFild;
  final PokemonType? type;
  final PokemonType? subType;
  final Map<PokemonStats, RangeValues>? stats;
  final PokemonGenerations? generation;
}
