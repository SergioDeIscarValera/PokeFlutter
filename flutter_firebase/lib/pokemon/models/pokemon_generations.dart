import 'package:flutter/material.dart';

enum PokemonGenerations { I, II, III, IV, V, VI, VII, VIII, IX, Other }

extension PokemonGenerationsUtils on PokemonGenerations {
  String get name {
    switch (this) {
      case PokemonGenerations.I:
        return "Red and Blue";
      case PokemonGenerations.II:
        return "Gold and Silver";
      case PokemonGenerations.III:
        return "Ruby and Sapphire";
      case PokemonGenerations.IV:
        return "Diamond and Pearl";
      case PokemonGenerations.V:
        return "Black and White";
      case PokemonGenerations.VI:
        return "X and Y";
      case PokemonGenerations.VII:
        return "Sun and Moon";
      case PokemonGenerations.VIII:
        return "Sword and Shield";
      case PokemonGenerations.IX:
        return "Scarlet and Violet";
      default:
        return "Other";
    }
  }

  Gradient get gradient {
    switch (this) {
      case PokemonGenerations.I:
        return const LinearGradient(
          colors: [
            Color(0xFFff0000),
            Color(0xFF0000ff),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.II:
        return const LinearGradient(
          colors: [
            Color(0xFFd2c21a),
            Color(0xFFa0a0a0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.III:
        return const LinearGradient(
          colors: [
            Color(0xFFb90303),
            Color(0xFF0d00b8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.IV:
        return const LinearGradient(
          colors: [
            Color(0xFF6077ff),
            Color(0xFFfc72e4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.V:
        return const LinearGradient(
          colors: [
            Color(0xFF424242),
            Color(0xFFf2f2f2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.VI:
        return const LinearGradient(
          colors: [
            Color(0xFF0084c3),
            Color(0xFF8f0305),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.VII:
        return const LinearGradient(
          colors: [
            Color(0xFFffa500),
            Color(0xFFb401ff),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.VIII:
        return const LinearGradient(
          colors: [
            Color(0xFF00a8ee),
            Color(0xFFff0060),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.IX:
        return const LinearGradient(
          colors: [
            Color(0xFFa2130a),
            Color(0xFF500d69),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case PokemonGenerations.Other:
        return const LinearGradient(
          colors: [
            Color(0xFF000000),
            Color(0xFF000000),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
