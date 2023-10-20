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

extension PokemonTypeNamed on PokemonType {
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
}
