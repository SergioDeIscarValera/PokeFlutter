enum PokemonGenerations { I, II, III, IV, V, VI, VII, VIII, IX, Other }

extension PokemonGenerationsNamed on PokemonGenerations {
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
}
